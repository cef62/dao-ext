package com.comtaste.sql.daogenerator.model
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import com.comtaste.sql.daogenerator.DaoGenFacade;
	
	import flash.events.ErrorEvent;
	import flash.filesystem.File;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ApplicationUpdaterProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ApplicationUpdaterProxy";
		
		
		
		public function ApplicationUpdaterProxy()
		{
			super(NAME, false);
			initUpdater();
		}

/*************************************************************************
 * properties		
*************************************************************************/	
		
		/**
		 * UPDATE MANAGER
		 */
		private var updater : ApplicationUpdaterUI;

		private var _connectionAvailable  : Boolean = false;
		


/*************************************************************************
 * data accessor		
*************************************************************************/	
			


/*************************************************************************
 * proxy registration and de-registration		
*************************************************************************/	
		
		override public function onRegister():void
		{
		}
		
		override public function onRemove():void
		{
		}
		
/*************************************************************************
 * PRIVATE API		
*************************************************************************/	
			
		
		private function initUpdater():void 
		{
			if( _connectionAvailable && updater == null )
			{
				// initialize application updater
				updater = new ApplicationUpdaterUI();
				updater.configurationFile = File.applicationDirectory.resolvePath( "config/updaterConfig.xml" );
				updater.addEventListener(UpdateEvent.INITIALIZED, onUpdaterInitialized );
				updater.addEventListener(ErrorEvent.ERROR, onUpdaterError );
				updater.initialize();
			}
		}
		


/*************************************************************************
 * Updater event listeners		
*************************************************************************/
			
		private function onUpdaterInitialized( evt:UpdateEvent ):void 
		{
            updater.checkNow();
        }
        
        private function onUpdaterError( evt:ErrorEvent ):void 
        {
            updater.cancelUpdate();
            
			var msg:String = "An update is available but the application could not be updated. Please try again later.";
            
            sendNotification( DaoGenFacade.APP_UPDATE_FAILED, msg );
        } 
		
				
		
/*************************************************************************
 * PUBLIC API		
*************************************************************************/	
		
		public function setConnectionAvailable( val:Boolean ):void
		{
			_connectionAvailable = val;
			initUpdater();
		}
		
		
		
	}
}