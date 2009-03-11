package com.comtaste.sql.daogenerator.model
{
	import flash.data.SQLColumnSchema;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class VOGeneratorProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "VOGeneratorProxy";
		
		
		// constructor
		public function VOGeneratorProxy()
		{
			super(NAME, false);
		}

/*************************************************************************
 * properties		
*************************************************************************/	
		
		private static var LV1 : String = "\t";
		private static var LV2 : String = "\t\t";
		private static var LV3 : String = "\t\t\t";
		private static var LV4 : String = "\t\t\t\t";
		private static var LV5 : String = "\t\t\t\t\t";
		private static var RETURN : String = File.lineEnding;
		


/*************************************************************************
 * data accessor		
*************************************************************************/	
			


/*************************************************************************
 * proxy registration and de-registration		
*************************************************************************/	
		
		override public function onRegister():void
		{
		}
		
		override public function onRemove():void
		{
		}
		
/*************************************************************************
 * PRIVATE API		
*************************************************************************/	
			
		private function ensureFolderTree( destinationFolder:File, voNamespace:String ):File
		{
			var folders:Array = voNamespace.split( "." );
			var subFolderName:String;
			
			var folder:File = new File( destinationFolder.url );
			var subFolder:File;
			
			for each( subFolderName in folders )
			{
				subFolder = folder.resolvePath( subFolderName );
				if( !subFolder.exists )
					subFolder.createDirectory();
				
				folder = subFolder;
				subFolder = null;
			}
			
			return folder;
		}
		
/*************************************************************************
 * PUBLIC API		
*************************************************************************/	
			
		
		public function generateTableVOString( tableName:String, columns:Array, voNamespace:String = "" ):String
		{
			var beanSetterGetter:String = '';
			
			// cycle all the variables in SQLColumnSchema ( columns of the table ) and also generate methods ( get and set )
			var col:SQLColumnSchema;
			for each( col in columns ) 
			{
				var columnName:String 		= col.name;
				var columnType:String		= col.dataType;
				
				switch( columnType.toLowerCase() ) 
				{
					case 'text':
					case 'varchar':
						columnType = 'String';
						break;
					
					case 'numeric':
					case 'real':
					case 'float':
						columnType = 'Number';
						break;

					case 'integer':
						columnType = 'int';
						break;
					
					case 'date':
						columnType = 'Date';
						break;
						
					case 'xml':
						columnType = 'XML';
						break;
						
					case 'boolean':
						columnType = 'Boolean';
						break;
						
						
					case 'blob':
					default:
						columnType = 'Object';
						break;
				}
				
				beanSetterGetter = beanSetterGetter + 
						RETURN+LV2+"private var _" + columnName + " : " + columnType + ";" +
						RETURN+LV2+"public function get " + columnName + "() : " + columnType + " {" + 
						RETURN+LV3+"return _" + columnName + ";" +
						RETURN+LV2+"}" +
						RETURN+LV2+"" +
						RETURN+LV2+"public function set " + columnName + "( value : " +  columnType + " ) : void  {" + 
						RETURN+LV3+"_" + columnName + " = value;" + 
						RETURN+LV2+"}" +
						RETURN+LV2;
			}
			
			// VO generated
			var voString:String = 
						"package " + voNamespace + 
						RETURN+"{" + 
						RETURN+LV1+"/**" + 
						RETURN+LV1+" * @author www.comtaste.com" + 
						RETURN+LV1+"*/" + 
						RETURN+LV1+"[Bindable]" + 
						RETURN+LV1+"public class " + tableName + "VO" + " {" + 
						RETURN+LV2+"" +
						RETURN+LV2+"public function " + tableName + "VO" + "() {" + 
						RETURN+LV2+"}" + 
						RETURN+LV2+"" +
						beanSetterGetter +
						RETURN+LV1+"}" + 
						RETURN+"}" + 
						RETURN;
			return voString;
		}
		
		
		public function writeVOToFile( tableName:String, voString:String, destinationFolder:File, voNamespace:String = "" ):String
		{
			if( voNamespace != null && voNamespace != "" )
				destinationFolder = ensureFolderTree( destinationFolder, voNamespace );
			
			var file:File = destinationFolder.resolvePath( tableName + 'VO.as' );
			if ( file.exists ) 
				file.deleteFile();
			
			try
			{
				// open a FileStrean
				var fileStream:FileStream = new FileStream();
				fileStream.open( file, FileMode.WRITE );
				// write file
				fileStream.writeUTFBytes( voString );
				// close the stream
				fileStream.close();
			}
			catch( er:Error )
			{
				return null;
			}
			
			var fullyQualifiedName:String = file.url.split( "/" ).pop().toString();
			fullyQualifiedName = fullyQualifiedName.split( "." ).shift().toString(); 
			fullyQualifiedName = voNamespace + "." + fullyQualifiedName;
			
			return fullyQualifiedName;
		}
		
		
	}
}