package com.comtaste.sql.daogenerator.commands
{
    import com.comtaste.sql.daogenerator.DaoGenFacade;
    import com.comtaste.sql.daogenerator.model.DaoGenModelLocator;
    
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.net.FileFilter;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
    import org.puremvc.as3.patterns.observer.*;
    
    public class ChooseDatabaseFileCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            var file:File = File.applicationDirectory;
			var filter:FileFilter = new FileFilter( "SQLite DB", "*.*" );
			
			try 
			{
			    file.browseForOpen( "Select an SQLite DB", [ filter ] );
			    file.addEventListener( Event.SELECT, fileSelected );
			}
			catch (error:Error)
			{
			    trace("Open DB Failed:", error.message);
			}
		}
	
		private function fileSelected( evt:Event ):void 
		{

		    // file db scelto
		    var file:File = evt.target as File;
		    
		    // scriviamo log
		    sendNotification( DaoGenFacade.WRITELOG, null, "Selezionato file: " + file.url ); 
		    
		    // memorizziamo percorso
		    DaoGenModelLocator.getInstance().currentFile = file;
		    // rimuoviamo precedenti dati
			DaoGenModelLocator.getInstance().availableTables.removeAll();
		    
		    // richiediamo caricamento dello schema SQL
		    sendNotification( DaoGenFacade.LOAD_SQL_SCHEMA, file );
		}

        
    }
}
