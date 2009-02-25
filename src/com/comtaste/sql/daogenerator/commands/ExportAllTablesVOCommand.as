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
    
    public class ExportAllTablesVOCommand extends SimpleCommand
    {
		
        override public function execute( note:INotification ) :void    
		{
			var rowDetails:TableDetailsRowVO;
			var tableSchema:SQLTableSchema;
			for each( tableSchema in DaoGenModelLocator.getInstance().availableTables )
			{
				rowDetails = new TableDetailsRowVO;
				rowDetails.tableName = tableSchema.name;
				
				rowDetails.voNamespace = DaoGenModelLocator.getInstance().globalNamespaceVO;
				rowDetails.exportVO = true;
				
				sendNotification( DaoGenFacade.EXPORT_TABLE_CONTENT_REQUEST, rowDetails );
			}
		}
        
    }
}
