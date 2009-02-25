package com.comtaste.sql.daogenerator.view
{
    import com.comtaste.sql.daogenerator.DaoGenFacade;
    import com.comtaste.sql.daogenerator.model.vo.GlobalNamespaceUpdateVO;
    import com.comtaste.sql.daogenerator.view.components.LogView;
    import com.comtaste.sql.daogenerator.view.components.TableDetailsRow;
    
    import flash.data.SQLTableSchema;
    import flash.events.Event;
    import flash.system.Capabilities;
    
    import mx.collections.ArrayCollection;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
   
    public class DaoGenApplicationMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "DaoGenApplicationMediator";
        
        public function DaoGenApplicationMediator( viewComponent:Object ) 
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
			facade.registerMediator( new MainControlsMediator( app.sqlControlsBar ) );
			
			var logWin:LogView = new LogView();
			logWin.open();
			facade.registerMediator( new LogViewMediator( logWin ) );
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
					clearTableRowsContainer();
					populateTableRowsContainer( note.getBody() as ArrayCollection );
					break;
					
				default:
					break;
            }
        }



/*************************************************************************
 * PRIVATE API		
*************************************************************************/	
		
		private function clearTableRowsContainer():void
		{
			app.clearTableRows();
		}
		
		private function populateTableRowsContainer( tables:ArrayCollection ):void
		{
			var rowView:TableDetailsRow;
			var tableSchema:SQLTableSchema;
			
			for each( tableSchema in tables )
			{
				// generate row component
				rowView = new TableDetailsRow();
				rowView.initialize();
				
				rowView.setTableName( tableSchema.name );
				
				if( app.globalVONamespace.text.length > 0 )
					rowView.setNamespaceVO( app.globalVONamespace.text );
				
				if( app.globalDAONamespace.text.length > 0 )
				rowView.setNamespaceDAO( app.globalDAONamespace.text );
				
				
				// generate and register row mediator			
				facade.registerMediator( new TableDetailsRowMediator( tableSchema.name, rowView ) );  
				
				// put on screen
				app.addTableRow( rowView );
			}
			
			app.validateNow();
		}
		
/*************************************************************************
 * VIEW EVENT HANDLERS		
*************************************************************************/	

		private function updateGlobalNamespaceVO( evt:Event ):void
		{
			var vo:GlobalNamespaceUpdateVO = new GlobalNamespaceUpdateVO();
			vo.force = false;
			vo.newValue = app.globalVONamespace.text; 
			sendNotification( DaoGenFacade.UPDATE_GLOBAL_NAMESPACE_VO_REQUEST, vo );
		}

		private function updateGlobalNamespaceDAO( evt:Event ):void
		{
			var vo:GlobalNamespaceUpdateVO = new GlobalNamespaceUpdateVO();
			vo.force = false;
			vo.newValue = app.globalDAONamespace.text; 
			sendNotification( DaoGenFacade.UPDATE_GLOBAL_NAMESPACE_DAO_REQUEST, vo );
		}

		private function forceNamespaceUpdate( evt:Event ):void
		{
			var vo:GlobalNamespaceUpdateVO;
			
			vo = new GlobalNamespaceUpdateVO();
			vo.force = true;
			vo.newValue = app.globalVONamespace.text; 
			sendNotification( DaoGenFacade.UPDATE_GLOBAL_NAMESPACE_VO_REQUEST, vo );

			vo = new GlobalNamespaceUpdateVO();
			vo.force = true;
			vo.newValue = app.globalDAONamespace.text; 
			sendNotification( DaoGenFacade.UPDATE_GLOBAL_NAMESPACE_DAO_REQUEST, vo );
		}
		
/*************************************************************************
 * App inizialization		
*************************************************************************/	
		
		

		private function init() : void 
		{
			// center application
			centerApp();
			
			// event listeners
			app.addEventListener( DAOGenerator.UPDATE_GLOBAL_NAMESPACE_VO, updateGlobalNamespaceVO, false, 0, true );
			app.addEventListener( DAOGenerator.UPDATE_GLOBAL_NAMESPACE_DAO, updateGlobalNamespaceDAO, false, 0, true );
			app.addEventListener( DAOGenerator.FORCE_NAMESPACE_UPDATE, forceNamespaceUpdate, false, 0, true );
		}
		
		
		
		/**
		 * center application
		 * 
		 */
		private function centerApp() : void 
		{
			app.stage.nativeWindow.x	= ( Capabilities.screenResolutionX - app.width ) / 2;
			app.stage.nativeWindow.y	= ( Capabilities.screenResolutionY - app.height ) / 2;
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
		
        protected function get app():DAOGenerator
		{
            return viewComponent as DAOGenerator;
        }

    }
}
