package com.comtaste.sql.daogenerator.events
{
	import com.comtaste.sql.daogenerator.model.vo.TableDetailsRowVO;
	
	import flash.events.Event;
	
	[Event(name="exportContent", type="com.comtaste.sql.daogenerator.events.TableDetailsRowEvent")]
	public class TableDetailsRowEvent extends Event
	{
		public static const EXPORT_CONTENT : String = "exportContent";
		
		private var _tableDetails : TableDetailsRowVO = new TableDetailsRowVO();
		public function get tableDetails():TableDetailsRowVO
		{
			return _tableDetails;
		} 
		
		public function TableDetailsRowEvent( type:String, tableDetails:TableDetailsRowVO, bubbles:Boolean=false, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
			
			this._tableDetails = tableDetails;
			
			if( this.tableDetails.exportDAO && this.tableDetails.daoName == null )
				throw new Error( "Impossible generate a DAO export request without a given name for DAO class" );
		}
		
		override public function clone():Event
		{
			return new TableDetailsRowEvent( this.type, this._tableDetails, this.bubbles, this.cancelable );
		} 
		
	}
}