package com.comtaste.sql.daogenerator.model
{
	import air.net.URLMonitor;
	
	import com.comtaste.sql.daogenerator.DaoGenFacade;
	
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class NetMonitorProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "NetMonitorProxy";
		
		
		
		public function NetMonitorProxy()
		{
			super(NAME, false);
			initMonitor();
		}

/*************************************************************************
 * properties		
*************************************************************************/	
		/**
		 * URL MONITOR
		 */
		private var monitor:URLMonitor;


/*************************************************************************
 * data accessor		
*************************************************************************/	
			
		public function getStatus():Boolean
		{
			if( monitor.running )
				return monitor.available;
			else
				return false;
		}


/*************************************************************************
 * proxy registration and de-registration		
*************************************************************************/	
		
		override public function onRegister():void
		{
			start();
		}
		
		override public function onRemove():void
		{
			stop();
		}
		
/*************************************************************************
 * PRIVATE API		
*************************************************************************/	
			
		
		private function initMonitor():void 
		{
			monitor = new URLMonitor( new URLRequest( 'http://www.comtaste.com' ) ); 
			monitor.addEventListener( StatusEvent.STATUS, announceStatus ); 
		}
		
		
		/**
		 * Handler chiamato ad ogni cambio di stato di connessione
		 * 
		 */
		private function announceStatus( evt:StatusEvent ):void 
		{ 
			sendNotification( DaoGenFacade.NET_STATUS_CHANGED, getStatus() );
		}
		
/*************************************************************************
 * PUBLIC API		
*************************************************************************/	
			
		
		public function start():void
		{
			monitor.start();
		}

		public function stop():void
		{
			monitor.stop();
		}
		
		
		
		
	}
}