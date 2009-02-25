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
    
    public class ChooseDestinationFolderCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
            var file:File = new File();
			
			try 
			{
			    file.browseForDirectory( "Chose destination folder" );
			    file.addEventListener( Event.SELECT, folderSelected );
			}
			catch (error:Error)
			{
			    trace("Failed:", error.message);
			}
		}
	
		private function folderSelected( evt:Event ):void 
		{
		    // file db scelto
		    var file:File = evt.target as File;
		    
		    // scriviamo log
		    sendNotification( DaoGenFacade.WRITELOG, null, "Destination choosen: " + file.url ); 
		    
		    // memorizziamo percorso
		    DaoGenModelLocator.getInstance().destinationFolder = file;
		    
		    // richiediamo caricamento dello schema SQL
		    sendNotification( DaoGenFacade.CHOOSE_DESTINATION_RESULT, file );
		}

        
    }
}
