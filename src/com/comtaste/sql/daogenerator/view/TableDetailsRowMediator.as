package com.comtaste.sql.daogenerator.view
{
    import com.comtaste.sql.daogenerator.DaoGenFacade;
    import com.comtaste.sql.daogenerator.events.TableDetailsRowEvent;
    import com.comtaste.sql.daogenerator.model.vo.GlobalNamespaceUpdateVO;
    import com.comtaste.sql.daogenerator.view.components.TableDetailsRow;
    
    import flash.events.Event;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
    
   
    public class TableDetailsRowMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = "TableDetailsRowMediator";
        
        public function TableDetailsRowMediator( name:String, viewComponent:Object ) 
        {
            super( name, viewComponent );
			
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
            list.push( DaoGenFacade.UPDATE_GLOBAL_NAMESPACE_DAO_REQUEST );
            list.push( DaoGenFacade.UPDATE_GLOBAL_NAMESPACE_VO_REQUEST );
            return list;
        }

        override public function handleNotification( note:INotification ):void 
        {
        	var globalUpdateVO:GlobalNamespaceUpdateVO;
        	
            switch ( note.getName() ) 
			{
				case DaoGenFacade.UPDATE_GLOBAL_NAMESPACE_DAO_REQUEST:
					globalUpdateVO = note.getBody() as GlobalNamespaceUpdateVO;
					
					if( globalUpdateVO.force )
						component.setNamespaceDAO( globalUpdateVO.newValue );
					break;

				case DaoGenFacade.UPDATE_GLOBAL_NAMESPACE_VO_REQUEST:
					globalUpdateVO = note.getBody() as GlobalNamespaceUpdateVO;
					
					if( globalUpdateVO.force )
						component.setNamespaceVO( globalUpdateVO.newValue );
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

		private function destroy( evt:Event ):void
		{
			facade.removeMediator( this.getMediatorName() );
		}

		private function exportRowContent( evt:TableDetailsRowEvent ):void
		{
			sendNotification( DaoGenFacade.EXPORT_TABLE_CONTENT_REQUEST, evt.tableDetails );
		}

		
		
/*************************************************************************
 * App inizialization		
*************************************************************************/	
		
		

		private function init() : void 
		{
			// enter event listener on view
			component.addEventListener( TableDetailsRow.DESTROY_ROW, destroy, false, 0, true );
			component.addEventListener( TableDetailsRowEvent.EXPORT_CONTENT, exportRowContent, false, 0, true );
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
		
        protected function get component():TableDetailsRow
		{
            return viewComponent as TableDetailsRow;
        }

    }
}
