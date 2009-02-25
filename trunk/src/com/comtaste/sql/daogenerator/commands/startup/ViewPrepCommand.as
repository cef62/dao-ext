package com.comtaste.sql.daogenerator.commands.startup
{
    import com.comtaste.sql.daogenerator.view.DaoGenApplicationMediator;
    
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
    public class ViewPrepCommand extends SimpleCommand
    {
        override public function execute( note:INotification ) :void    
		{
			// Register the ApplicationMediator
			facade.registerMediator( new DaoGenApplicationMediator( note.getBody() ) );    
        }

        
    }
}
