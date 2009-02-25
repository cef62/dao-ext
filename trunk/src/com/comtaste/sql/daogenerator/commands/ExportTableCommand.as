package com.comtaste.sql.daogenerator.commands
{
    import com.comtaste.sql.daogenerator.DaoGenFacade;
    import com.comtaste.sql.daogenerator.model.DAOGeneratorProxy;
    import com.comtaste.sql.daogenerator.model.DaoGenModelLocator;
    import com.comtaste.sql.daogenerator.model.VOGeneratorProxy;
    import com.comtaste.sql.daogenerator.model.vo.TableDetailsRowVO;
    
    import flash.data.SQLTableSchema;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
    import org.puremvc.as3.patterns.observer.*;
    
    public class ExportTableCommand extends SimpleCommand
    {
		
    	private var rowDetails:TableDetailsRowVO;
    	private var tableSchema:SQLTableSchema;
    	private var voString:String;
    	private var daoString:String;
    	private var fullVOName:String;
    	
        override public function execute( note:INotification ) :void    
		{
			rowDetails = note.getBody() as TableDetailsRowVO;
			
			tableSchema = DaoGenModelLocator.getInstance().getTableSchemaByName( rowDetails.tableName );
			
			if( tableSchema != null )
			{
				if( rowDetails.exportVO )
					exportVO();
				
				if( rowDetails.exportDAO )
					exportDAO();
				
				sendNotification( DaoGenFacade.EXPORT_TABLE_CONTENT_DONE );  
			}
			else
			{
				// TODO generare notifica errore
			}
		}
		
		
		private function exportVO():void
		{
			var voProxy:VOGeneratorProxy = facade.retrieveProxy( VOGeneratorProxy.NAME ) as VOGeneratorProxy;
			
			// generazione del VO
			voString = voProxy.generateTableVOString( rowDetails.tableName, tableSchema.columns, rowDetails.voNamespace );
			
			fullVOName = voProxy.writeVOToFile( rowDetails.tableName, voString, DaoGenModelLocator.getInstance().destinationFolder, rowDetails.voNamespace );
			
			// scriviamo log
		    sendNotification( DaoGenFacade.WRITELOG, null, "VO Created" );
		}
		
		private function exportDAO():void
		{
			var daoProxy:DAOGeneratorProxy = facade.retrieveProxy( DAOGeneratorProxy.NAME ) as DAOGeneratorProxy;
			
			if( fullVOName == null )
				fullVOName = "Object";
			
			// generazione del DAO
			daoString = daoProxy.generateTableDAOString( rowDetails.tableName, fullVOName, tableSchema.columns, tableSchema.sql, rowDetails.daoName );
			
			var result:Boolean = daoProxy.writeDAOToFile( rowDetails.tableName, daoString, DaoGenModelLocator.getInstance().destinationFolder, rowDetails.daoName );
			
			// scriviamo log
			sendNotification( DaoGenFacade.WRITELOG, null, "DAO Created" );
		}
	

        
    }
}
