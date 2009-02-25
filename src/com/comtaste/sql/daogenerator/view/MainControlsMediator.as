package com.comtaste.sql.daogenerator.view
{
    import com.comtaste.sql.daogenerator.DaoGenFacade;
    import com.comtaste.sql.daogenerator.view.components.MainControls;
    
    import flash.events.Event;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
   
    public class MainControlsMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "MainControlsMediator";
        
        public function MainControlsMediator( viewComponent:Object ) 
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
            list.push( DaoGenFacade.LOAD_SQL_SCHEMA_RESULT );
            return list;
        }

        override public function handleNotification( note:INotification ):void 
        {
            switch ( note.getName() ) 
			{
				case DaoGenFacade.LOAD_SQL_SCHEMA_RESULT:
					component.generateDAOBtn.enabled = true;
					component.generateVOBtn.enabled = true;
					component.generateDAOandVOBtn.enabled = true;
					component.chooseDestinationBtn.enabled = true;
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

		private function openFile( evt:Event ):void
		{
			sendNotification( DaoGenFacade.CHOOSE_DATABASE );
		}

		private function generateDAO( evt:Event ):void
		{
			sendNotification( DaoGenFacade.GENERATE_DATABASE_DAO );
		}
		
		private function generateVO( evt:Event ):void
		{
			sendNotification( DaoGenFacade.GENERATE_DATABASE_VO );
		}

		private function generateDAOandVO( evt:Event ):void
		{
			sendNotification( DaoGenFacade.GENERATE_DATABASE_COMPLETE );
		}
		
		private function chooseDestination( evt:Event ):void
		{
			sendNotification( DaoGenFacade.CHOOSE_DESTINATION );
		}
	
		private function openLog( evt:Event ):void
		{
			sendNotification( DaoGenFacade.OPEN_LOG_VIEW );
		}
		
/*************************************************************************
 * App inizialization		
*************************************************************************/	
		
		

		private function init() : void 
		{
			// enter event listener on view
			component.addEventListener( MainControls.OPEN_FILE, openFile, false, 0, true );
			component.addEventListener( MainControls.GENERATE_DAO, generateDAO, false, 0, true );
			component.addEventListener( MainControls.GENERATE_VO, generateVO, false, 0, true );
			component.addEventListener( MainControls.GENERATE_DAO_AND_VO, generateDAOandVO, false, 0, true );
			component.addEventListener( MainControls.CHOOSE_DESTINATION, chooseDestination, false, 0, true );
			component.addEventListener( MainControls.OPEN_LOG_WINDOW, openLog, false, 0, true );
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
		
        protected function get component():MainControls
		{
            return viewComponent as MainControls;
        }

    }
}
