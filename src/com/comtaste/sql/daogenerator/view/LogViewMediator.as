package com.comtaste.sql.daogenerator.view
{
    import com.comtaste.sql.daogenerator.DaoGenFacade;
    import com.comtaste.sql.daogenerator.view.components.LogView;
    
    import flash.events.Event;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
   
    public class LogViewMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "LogViewMediator";
        
        public function LogViewMediator( viewComponent:Object ) 
        {
            super( NAME, viewComponent );
			
			init();
        }

/*************************************************************************
 * properties		
*************************************************************************/	
		
		
		
/*************************************************************************
 * mediator registration and de-registration		
*************************************************************************/	
			
		override public function onRegister():void
		{
		}
		
		override public function onRemove():void
		{
		}
  

/*************************************************************************
 * Mediator NOTIFICATION management		
*************************************************************************/	
	     
        override public function listNotificationInterests():Array 
        {
            var list:Array = new Array();
            list.push( DaoGenFacade.OPEN_LOG_VIEW );
            list.push( DaoGenFacade.WRITELOG );
            return list;
        }

        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case DaoGenFacade.OPEN_LOG_VIEW:
					component.visible = true;
					component.orderToFront();
					break;

				case DaoGenFacade.WRITELOG:
					component.logConsole.text += note.getType() + "\n";
					break;
				
				default:
					break;
            }
        }



/*************************************************************************
 * PRIVATE API		
*************************************************************************/	
		
/*************************************************************************
 * VIEW EVENT HANDLERS		
*************************************************************************/	

		private function onClosing( evt:Event ):void
		{
			evt.preventDefault();
			evt.stopImmediatePropagation();
			
			component.visible = false;
		}
		
/*************************************************************************
 * App inizialization		
*************************************************************************/	
		
		private function init() : void 
		{
			component.addEventListener( Event.CLOSING, onClosing, false, 0, true );
		}

/*************************************************************************
 * Embedded assets		
*************************************************************************/

		
/*************************************************************************
 * Style Management		
*************************************************************************/

				
/*************************************************************************
 * view accessor		
*************************************************************************/	
		
        protected function get component():LogView
		{
            return viewComponent as LogView;
        }

    }
}
