package com.comtaste.sql.daogenerator.commands.status
{
    import com.comtaste.sql.daogenerator.model.ApplicationUpdaterProxy;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.command.*;
    import org.puremvc.as3.patterns.observer.*;
    
    /**
     * Prepare the View for use.
     * 
     * 
     * The Notification was sent by the Application,
     * and a reference to that view component was passed on the note body.
     * The ApplicationMediator will be created and registered using this
     * reference. The ApplicationMediator will then register 
     * all the Mediators for the components it created.
     * 
     */
    public class NetStatusChangedCommand extends SimpleCommand
    {
    	
        override public function execute( note:INotification ) :void    
		{
			var status:Boolean = Boolean( note.getBody() );
			( facade.retrieveProxy( ApplicationUpdaterProxy.NAME ) as ApplicationUpdaterProxy ).setConnectionAvailable( status );
        }
        
    }
}
