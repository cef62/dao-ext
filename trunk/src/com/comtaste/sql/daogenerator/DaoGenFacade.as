package com.comtaste.sql.daogenerator
{
    
    import com.comtaste.sql.daogenerator.commands.ChooseDatabaseFileCommand;
    import com.comtaste.sql.daogenerator.commands.ChooseDestinationFolderCommand;
    import com.comtaste.sql.daogenerator.commands.ExportAllTablesCompleteCommand;
    import com.comtaste.sql.daogenerator.commands.ExportAllTablesDAOCommand;
    import com.comtaste.sql.daogenerator.commands.ExportAllTablesVOCommand;
    import com.comtaste.sql.daogenerator.commands.ExportTableCommand;
    import com.comtaste.sql.daogenerator.commands.LoadDatabaseSchemaCommand;
    import com.comtaste.sql.daogenerator.commands.UpdateGlobalNamespaceDAOCommand;
    import com.comtaste.sql.daogenerator.commands.UpdateGlobalNamespaceVOCommand;
    import com.comtaste.sql.daogenerator.commands.startup.ApplicationStartupCommand;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.facade.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class DaoGenFacade extends Facade
    {
        // Notification name constants
        public static const STARTUP:String 					= "appStartup";
        public static const SHUTDOWN:String 				= "appShutdown";
		public static const APP_LOGOUT:String 				= "appLogout";
		public static const APP_LOGIN:String 				= "appLogin";
	
		
/**************************************************************
 * SQL GENERIC
**************************************************************/

		public static const DB_CONNECTION_ERROR:String 			= "databaseConnectionError";
		public static const DB_LOAD_SCHEMA_ERROR:String 		= "databaseLoadSchemaError";
		
		public static const OPEN_LOG_VIEW:String 				= "openLogView";
		
		public static const CHOOSE_DATABASE:String 				= "chooseDatabase";
		public static const CHOOSE_DESTINATION:String 			= "chooseDestination";
		public static const CHOOSE_DESTINATION_RESULT:String 	= "chooseDestinationResult";
		public static const LOAD_SQL_SCHEMA:String 				= "loadSQLSchema";
		public static const LOAD_SQL_SCHEMA_RESULT:String		= "loadSQLSchemaResult";
		
		public static const GENERATE_DATABASE_DAO:String 		= "generateDatabaseDAO";
		public static const GENERATE_DATABASE_VO:String 		= "generateDatabaseVO";
		public static const GENERATE_DATABASE_COMPLETE:String 	= "generateDatabaseComplete";

		public static const EXPORT_TABLE_CONTENT_REQUEST:String	= "exportTableContentsRequest";
		public static const EXPORT_TABLE_CONTENT_DONE:String	= "exportTableContentsDone";
		public static const EXPORT_TABLE_CONTENT_ERROR:String	= "exportTableContentsError";

		public static const UPDATE_GLOBAL_NAMESPACE_VO_REQUEST:String	= "updateGlobalNamespaceVORequest";
		public static const UPDATE_GLOBAL_NAMESPACE_DAO_REQUEST:String	= "updateGlobalNamespaceDAORequest";
		
		
	
/**************************************************************
 * 
**************************************************************/
		

		// navigation request
		public static const GO_TO_REQUEST:String			= "goToRequest";

		// Log request
		public static const WRITELOG:String					= "writeLog";






        /**
         * Singleton ApplicationFacade Factory Method
         */
        public static function getInstance() : DaoGenFacade 
		{
            if ( instance == null ) instance = new DaoGenFacade( );
            return instance as DaoGenFacade;
        }

        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController( ) : void 
        {
            super.initializeController(); 
            registerCommand( STARTUP, ApplicationStartupCommand );
            registerCommand( CHOOSE_DESTINATION, ChooseDestinationFolderCommand );
            registerCommand( CHOOSE_DATABASE, ChooseDatabaseFileCommand );
            registerCommand( LOAD_SQL_SCHEMA, LoadDatabaseSchemaCommand );
            registerCommand( EXPORT_TABLE_CONTENT_REQUEST, ExportTableCommand );

            registerCommand( UPDATE_GLOBAL_NAMESPACE_VO_REQUEST, UpdateGlobalNamespaceVOCommand );
            registerCommand( UPDATE_GLOBAL_NAMESPACE_DAO_REQUEST, UpdateGlobalNamespaceDAOCommand );

            registerCommand( GENERATE_DATABASE_VO, ExportAllTablesVOCommand );
            registerCommand( GENERATE_DATABASE_DAO, ExportAllTablesDAOCommand );
            registerCommand( GENERATE_DATABASE_COMPLETE, ExportAllTablesCompleteCommand );
        }
        
        public function startup( app:DAOGenerator ):void
        {
        	sendNotification( STARTUP, app );
        }
    }
}
