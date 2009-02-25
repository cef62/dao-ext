package com.comtaste.sql.daogenerator.model.vo
{
	public class GlobalNamespaceUpdateVO
	{
		private var _newValue : String;
		public function get newValue():String
		{
			return _newValue;
		}
		public function set newValue( value:String ):void
		{
			_newValue = value;
		}

		private var _force : Boolean = false;
		public function get force():Boolean
		{
			return _force;
		}
		public function set force( value:Boolean ):void
		{
			_force = value;
		}
	}
}