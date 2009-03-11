package com.comtaste.sql.daogenerator.commands
{
    import com.comtaste.sql.daogenerator.DaoGenFacade;
    import com.comtaste.sql.daogenerator.model.DaoGenModelLocator;
    
    import flash.data.SQLConnection;
    import flash.data.SQLMode;
    import flash.data.SQLSchemaResult;
    import flash.data.SQLTableSchema;
    import flash.filesystem.File;
    import flash.net.Responder;
    
    import mx.collections.ArrayCollection;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
    import org.puremvc.as3.patterns.observer.*;
    
    public class LoadDatabaseSchemaCommand extends SimpleCommand
    {
    	private var connection:SQLConnection;
    	
        override public function execute( note:INotification ) :void    
		{
            var file:File = note.getBody() as File;
            
            // otteniamo connessione a DB
        	connection = DaoGenModelLocator.getInstance().getSqlConnection();
        	
        	if( !connection.connected )
        	{
	        	try
	        	{
	        		// apre connessione sincrona
        			connection.open( file, SQLMode.CREATE );
        			
        			// carica schema
        			connection.loadSchema( null, null, "main", true, new Responder( onResult, onError ) );
        			
        			
        		} catch( e:Error )
        		{
    				sendNotification( DaoGenFacade.DB_CONNECTION_ERROR, file );
    				return;
        		}
        	}
        	else
        	{
            	sendNotification( DaoGenFacade.WRITELOG, null, "A database connection is already open." );
         	}
		
		}
		
		
		
		private function onResult( result:SQLSchemaResult ):void
		{
			connection.close();
			
			DaoGenModelLocator.getInstance().availableTables = new ArrayCollection( result.tables ); 
			DaoGenModelLocator.getInstance().availableIndices = new ArrayCollection( result.indices );
			
			//TODO add triggers 
			//TODO add views 
			
			/*
			* now DaoGenFacade.LOAD_SQL_SCHEMA_RESULT notification
			* transport the complete loaded SQLSchemaResult instance
			*/
			sendNotification( DaoGenFacade.LOAD_SQL_SCHEMA_RESULT, result );
			
			// scriviamo log
		    sendNotification( DaoGenFacade.WRITELOG, null, "Schema DB loaded" );
		}

		private function onError( errorObj:Object ):void
		{
			connection.close();
			
			sendNotification( DaoGenFacade.DB_LOAD_SCHEMA_ERROR, DaoGenModelLocator.getInstance().currentFile );
		}


        
    }
}
