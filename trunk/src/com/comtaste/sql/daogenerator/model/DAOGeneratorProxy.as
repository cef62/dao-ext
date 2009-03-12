package com.comtaste.sql.daogenerator.model
{
	import flash.data.SQLColumnSchema;
	import flash.data.SQLIndexSchema;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class DAOGeneratorProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DAOGeneratorProxy";
		
		
		// constructor
		public function DAOGeneratorProxy()
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
		
		private static var CREATE_INDEX_METHOD_PREFIX : String = "createIndex";
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
			folders.pop();
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
		
		
		
		private function defaultImport():String 
		{
			// dafault import package
			var sqlDEFAULT_IMPORT:String = 
						RETURN+LV1+"import flash.data.SQLConnection;" +
					    RETURN+LV1+"import flash.events.SQLEvent;" +
					    RETURN+LV1+"import flash.events.SQLErrorEvent;" +
					    RETURN+LV1+"import flash.data.SQLStatement;" +
					    RETURN+LV1+"import flash.errors.SQLError;" +
						RETURN+LV1+"import mx.collections.ArrayCollection;" +
					    RETURN+LV1+"import mx.controls.Alert;";
    		return sqlDEFAULT_IMPORT;
		}
		
		private function defaultDAO( parameters:ArrayCollection ):String 
		{
			var sqlDEFAULT:String = 
						RETURN+LV2+"private function setParameters( stmt:SQLStatement, params:Array ):void {" +
						RETURN+LV3+"for ( var i:int = 0; i < params.length; i++ ) {" +
						RETURN+LV4+"stmt.parameters[ i+1 ] = params[ i ] == null ? \"\" : params[ i ];" +
						RETURN+LV3+"}" +
						RETURN+LV2+"}" +
						RETURN+LV2 +
						RETURN+LV2+"private function sqlErrorHandler( event:SQLError ):void {" +
						RETURN+LV3+"Alert.show( event.message, \"Error\" );" +
						RETURN+LV2+"}" +
						RETURN+LV2;
			return sqlDEFAULT;
		}

		private function singletonBlock( daoClass:String ):String 
		{
			// singleton function
			var sqlSINGLETON:String = 
						RETURN+LV2+"private static var instance:" + daoClass + ";" +
						RETURN+LV2+"public static function getInstance():" + daoClass + " {" +
						RETURN+LV3+"if( instance == null )" +
						RETURN+LV4+"instance = new " + daoClass + "( new SingletonLock );" +
						RETURN+LV3+"return instance;" +
						RETURN+LV2+"}" +
						RETURN+LV2;
			return sqlSINGLETON;
		}
		
		
		private function getDAO( tableName:String, voClass:String="Object" ):String 
		{
			// select function
			var sqlSELECT:String = 
						RETURN+LV2+"public function getTableContent( resultHandler:Function, faultHandler:Function = null ):void {" + 
						RETURN+LV3+"var stmt:SQLStatement = new SQLStatement();" + 
						RETURN+LV3+"stmt.sqlConnection = sqlConnection;" + 
						RETURN+LV3+"stmt.text = 'SELECT * FROM " + tableName + ";';";
						
				if( voClass != null && voClass != "Object" && voClass != "" )
					sqlSELECT += RETURN+LV3+"stmt.itemClass = " + voClass + ";";
						
				sqlSELECT +=		
						RETURN+LV3+"stmt.addEventListener( SQLEvent.RESULT," + 
						RETURN+LV3+"function ( event:SQLEvent ):void {" + 
						RETURN+LV4+"resultHandler.call( this, new ArrayCollection( stmt.getResult().data ) );" + 
						RETURN+LV3+"});" + 
						RETURN+LV3+"stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );" + 
						RETURN+LV3+"stmt.execute();" + 
						RETURN+LV2+"}" + 
						RETURN+LV2;
			return sqlSELECT;
		}
		
		private function updateDAO( tableName:String, parameters:ArrayCollection, voClass:String="Object" ):String 
		{
			var resultValue:String 		= "";
			var resultValueVO:String 	= "";
			var value:String;
			for each ( value in parameters ) 
			{
				resultValue 	= resultValue + value + " = ? , ";
				resultValueVO	= resultValueVO + 'rowItem.' + value + ', ';
			}
			resultValueVO 	= resultValueVO.substr( 0, resultValueVO.length - 2 );
			
			// update function
			var sqlUPDATE:String = 
						RETURN+LV2+"public function updateRow( rowItem:" + voClass + ", resultHandler:Function = null, faultHandler:Function = null ):void {" +  
						RETURN+LV3+"var stmt:SQLStatement = new SQLStatement();" + 
						RETURN+LV3+"stmt.sqlConnection = sqlConnection;" + 
						RETURN+LV3+"stmt.text = 'UPDATE " + tableName + " SET " + resultValue + " WHERE ID = ?;';" + 
						RETURN+LV3+"setParameters( stmt, [ " + resultValueVO + " ] );" + 
						RETURN+LV3+"stmt.addEventListener( SQLEvent.RESULT," + 
						RETURN+LV3+"function ( event:SQLEvent ):void {" + 
						RETURN+LV4+"if ( resultHandler != null ) resultHandler.call( this, rowItem );" + 
						RETURN+LV3+"});" + 
						RETURN+LV3+"stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );" + 
						RETURN+LV3+"stmt.execute();" + 
						RETURN+LV2+"}" + 
						RETURN+LV2;
			return sqlUPDATE;
		}
		
		private function insertDAO( tableName:String, parameters:ArrayCollection, autoIncrementField:String = null, voClass:String="Object" ):String 
		{
			var resultValue:String 			= "";
			var resultValueVOSql:String 	= "";
			var resultValueVO:String 		= "";
			var value:String;
			for each ( value in parameters ) 
			{
				// skip autoincrement field
				if( autoIncrementField != null && autoIncrementField == value )
					continue;
					
				resultValue 		= resultValue + value + ", ";
				resultValueVOSql	= resultValueVOSql + '?,';
				resultValueVO		= resultValueVO + 'rowItem.' + value + ', ';
			}

			// remove last comma if needed
			if( resultValue.length > 0 ) 
				resultValue 	= resultValue.substr( 0, resultValue.length - 1 );
			
			// remove last comma if needed
			if( resultValueVOSql.length > 0 )
				resultValueVOSql 	= resultValueVOSql.substr( 0, resultValueVOSql.length - 1 );
				
			// remove last comma if needed
			if( resultValueVO.length > 0 )
				resultValueVO 	= resultValueVO.substr( 0, resultValueVO.length - 1 );
			
			// insert function
			var sqlINSERT:String = 
						RETURN+LV2+"public function insertRow( rowItem:" + voClass + ", resultHandler:Function = null, faultHandler:Function = null ):void {" +  
						RETURN+LV3+"var stmt:SQLStatement = new SQLStatement();" + 
						RETURN+LV3+"stmt.sqlConnection = sqlConnection;" + 
						RETURN+LV3+"stmt.text = 'INSERT INTO " + tableName + "( " + resultValue + " ), VALUES ( " + resultValueVOSql + " );';" +
						RETURN+LV3+"var params:Array = [ " + resultValueVO + " ];" +
						RETURN+LV3+"setParameters( stmt, params );" + 
						RETURN+LV3+"stmt.addEventListener( SQLEvent.RESULT," + 
						RETURN+LV3+"function ( event:SQLEvent ):void {"; 
						
				if( autoIncrementField != null )
					sqlINSERT += RETURN+LV4+"if (!rowItem." + autoIncrementField + " > 0) rowItem." + autoIncrementField + " = stmt.getResult().lastInsertRowID;";
				
				sqlINSERT += 		
						RETURN+LV4+"if (resultHandler != null) resultHandler.call(this, rowItem);" +
						RETURN+LV3+"});" + 
						RETURN+LV3+"stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );" + 
						RETURN+LV3+"stmt.execute();" + 
						RETURN+LV2+"}" + 
						RETURN+LV2;
			return sqlINSERT;
		}
		
		private function deleteDAO( tableName:String, parameters:ArrayCollection, primaryKeys:Array, voClass:String="Object" ):String 
		{
			// ensure that a primary key exists
			if( primaryKeys == null || primaryKeys.length == 0 )
				throw new Error( "Impossible define a delete statement witohout any primary key" );
				
			// delete function
			var sqlDELETE:String = 
						RETURN+LV2+"public function deleteRow( rowItem:" + voClass + ", resultHandler:Function = null, faultHandler:Function = null ):void {" +  
						RETURN+LV3+"var stmt:SQLStatement = new SQLStatement();" + 
						RETURN+LV3+"stmt.sqlConnection = sqlConnection;" + 
						RETURN+LV3+"stmt.text = 'DELETE FROM " + tableName + " WHERE ";
						
			// apply correct execution conditions
			var fielName:String;
			for each( fielName in primaryKeys )
			{			
				sqlDELETE += fielName + " = " + tableName + "." + fielName + " AND ";
			}
			// remove last 'AND ' token
			var pos:int = sqlDELETE.lastIndexOf( " AND " );
			if( pos > 0 )
			{
				sqlDELETE = sqlDELETE.substring( 0, pos );
			}
			// close statement line
			sqlDELETE += ";';";
						
			sqlDELETE +=			
						RETURN+LV3+"stmt.addEventListener( SQLEvent.RESULT," + 
						RETURN+LV3+"function ( event:SQLEvent ):void {" + 
						RETURN+LV4+"if (resultHandler != null) resultHandler.call(this, rowItem);" +
						RETURN+LV3+"});" + 
						RETURN+LV3+"stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );" + 
						RETURN+LV3+"stmt.execute();" + 
						RETURN+LV2+"}" + 
						RETURN+LV2;
			return sqlDELETE;
		}
		
		private function createTableDAO( tableName:String, creationSQL:String ):String 
		{
			var pos:int = creationSQL.indexOf( "(" );
			creationSQL = creationSQL.substring( pos );
			
			// create table function
			var sqlCREATE:String =
						RETURN+LV2+"public function createTable( resultHandler:Function = null, faultHandler:Function = null ):void {" +  
						RETURN+LV3+"var stmt:SQLStatement = new SQLStatement();" + 
						RETURN+LV3+"stmt.sqlConnection = sqlConnection;" + 
						RETURN+LV3+"stmt.text = 'CREATE TABLE IF NOT EXISTS " + tableName + " " + creationSQL + ";';" +
						RETURN+LV3+"stmt.addEventListener( SQLEvent.RESULT," + 
						RETURN+LV3+"function ( event:SQLEvent ):void {" + 
						RETURN+LV4+"if (resultHandler != null) resultHandler.call(this);" +
						RETURN+LV3+"});" + 
						RETURN+LV3+"stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );" + 
						RETURN+LV3+"stmt.execute();" + 
						RETURN+LV2+"}" + 
						RETURN+LV2;
			return sqlCREATE;
		}
		
		private function createTableIndices( indices:Array ):String
		{
			if( indices == null || indices.length == 0 )
				return "";
			
			var sqlCREATE:String = "";
			
			var creationSQL:String;
			var indexSchema:SQLIndexSchema;
			for each( indexSchema in indices )
			{
				creationSQL = indexSchema.sql;
				var pos:int = creationSQL.indexOf( "ON " );
				if( pos < 0 )
					continue;
				creationSQL = creationSQL.substring( pos );
				
				sqlCREATE += 
					RETURN+LV2+"public function " + CREATE_INDEX_METHOD_PREFIX + indexSchema.name + "( resultHandler:Function = null, faultHandler:Function = null ):void {" +  
					RETURN+LV3+"var stmt:SQLStatement = new SQLStatement();" + 
					RETURN+LV3+"stmt.sqlConnection = sqlConnection;" + 
					RETURN+LV3+"stmt.text = 'CREATE UNIQUE INDEX IF NOT EXISTS " + indexSchema.database + "." + indexSchema.name + " " + creationSQL + ";';" +
					RETURN+LV3+"stmt.addEventListener( SQLEvent.RESULT," + 
					RETURN+LV3+"function ( event:SQLEvent ):void {" + 
					RETURN+LV4+"if (resultHandler != null) resultHandler.call(this);" +
					RETURN+LV3+"});" + 
					RETURN+LV3+"stmt.addEventListener( SQLErrorEvent.ERROR, faultHandler == null ? sqlErrorHandler : faultHandler );" + 
					RETURN+LV3+"stmt.execute();" + 
					RETURN+LV2+"}" + 
					RETURN+LV2;
			}
			
			return sqlCREATE;
		}
		
		
		private function createTableIndicesInitialization( indices:Array ):String
		{
			if( indices == null || indices.length == 0 )
				return "";
			
			var sqlCREATE:String = "";
			sqlCREATE += "// try to generate indices for this table";  
			
			var creationSQL:String;
			var indexSchema:SQLIndexSchema;
			for each( indexSchema in indices )
			{
				sqlCREATE +=  RETURN+LV3+ CREATE_INDEX_METHOD_PREFIX + indexSchema.name + "();"; 
			}
			
			return sqlCREATE;
		}
		
/*************************************************************************
 * PUBLIC API		
*************************************************************************/	
			
		public function generateTableDAOString( tableName:String, fullVOName:String, columns:Array, creationSQL:String, daoName:String, indices:Array = null ):String
		{
			var parameters:ArrayCollection = new ArrayCollection();
			
			//var primaryKey:String;
			var primaryKeyAutoIncrement:String;

			var primaryKeys:Array = new Array();
			var col:SQLColumnSchema;
			
			// cycle all the variables in SQLColumnSchema ( columns of the table ) and also generate methods
			for each( col in columns ) 
			{
				var columnName:String = col.name;
				var columnType:String = col.dataType;
				parameters.addItem( columnName );
				
				if( col.primaryKey )
					primaryKeys.push( col.name );
					
				if( col.autoIncrement && primaryKeyAutoIncrement == null )
					primaryKeyAutoIncrement = col.name;
			}
			
			
			var voClass:String			= fullVOName.split( "." ).pop();
			
			var tList:Array				= daoName.split( "." );
			tList.pop();
			var packageName:String		= tList.join( "." );
			var className:String		= daoName.split( "." ).pop();
			 
			var defaultImport:String	= defaultImport();
			var singletonDAO:String 	= singletonBlock( className );
			var defaultDAO:String 		= defaultDAO( parameters );
			
			var selectDAO:String;
			if( fullVOName != null || fullVOName != "" )
				selectDAO = getDAO( tableName, voClass );
			else
				selectDAO = getDAO( tableName );
				
				
			// clean 'cretaionSQL' from occasional TAB and RETURN escaped CARRIAGE (\n || \t)
			var regExp:RegExp = new RegExp("(\\t)|(\\n)", "g");
        	var cleanCreationSQL:String = creationSQL.replace( regExp, "" );	
			
			var updateDAO:String 		= updateDAO( tableName, parameters, voClass );
			var insertDAO:String 		= insertDAO( tableName, parameters, primaryKeyAutoIncrement, voClass );
			var deleteDAO:String 		= deleteDAO( tableName, parameters, primaryKeys, voClass );
			var createTableDAO:String 	= createTableDAO( tableName, cleanCreationSQL );
			
			var createTableIndices:String = createTableIndices( indices );
			var indicesInitialization:String = createTableIndicesInitialization( indices );
			
			
			var voString:String = 
						"package " + packageName +
						RETURN+"{" + 
						RETURN+LV1+"/**" + 
						RETURN+LV1+"* @author www.comtaste.com" + 
						RETURN+LV1+"*/" + 
						RETURN+LV1+"" +
						defaultImport +
						RETURN+LV1+"";
			
			if( fullVOName != null || fullVOName != "" )
			{
				voString += 
							RETURN+LV1+ "import " + fullVOName + ";" + 
							RETURN+LV1+"";
			}

			voString += 
						RETURN+LV1+"public class " + className + 
						RETURN+LV1+"{" +
						RETURN+LV1+"" +
						RETURN+LV2+ singletonDAO + 
						RETURN+LV1+"" +
						RETURN+LV2+"public function " + className + "( lock: SingletonLock) {" + 
						RETURN+LV2+"}" + 
						RETURN+LV1+"" +
						RETURN+LV2+"private var sqlConnection:SQLConnection;" +
						RETURN+LV2+"public function getConnection():SQLConnection {" +
						RETURN+LV3+"return sqlConnection;" +
						RETURN+LV2+"}" +
						RETURN+LV2+"public function setConnection( connection:SQLConnection ):void {" +
						RETURN+LV3+"// try construct table on Database any time a new connection is submitted" +
						RETURN+LV3+"createTable();" +
						RETURN+LV3+indicesInitialization +
						RETURN+LV3+"sqlConnection = connection;" +
						RETURN+LV2+"}" +
						RETURN+LV1+"" +
						createTableDAO +
						createTableIndices +
						selectDAO +
						updateDAO +
						insertDAO +
						deleteDAO +
						defaultDAO +
						RETURN+LV1+"}" + 
						RETURN+"}" + 
						RETURN +
						RETURN+"class SingletonLock {}" + 
						RETURN;
			
			return voString;
		}
		
		
		
		
		
		public function writeDAOToFile( tableName:String, daoString:String, destinationFolder:File, fullyQualifiedName:String = "" ):Boolean
		{
			if( fullyQualifiedName != null && fullyQualifiedName != "" )
			{
				destinationFolder = ensureFolderTree( destinationFolder, fullyQualifiedName );
				tableName = fullyQualifiedName.split( "." ).pop();
			}
			else
			{
				tableName += "_DAO"; 
			}
				
			var file:File = destinationFolder.resolvePath( tableName + '.as' );
			if ( file.exists ) 
				file.deleteFile();
			
			try
			{
				var fileStream:FileStream = new FileStream();
				fileStream.open( file, FileMode.WRITE );
				fileStream.writeUTFBytes( daoString );
				fileStream.close();
			}
			catch( er:Error )
			{
				return false;
			}
			
			return true;
		}
		
		
	}
}