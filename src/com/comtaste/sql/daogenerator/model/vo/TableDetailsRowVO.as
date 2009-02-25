package com.comtaste.sql.daogenerator.model.vo
{
	public class TableDetailsRowVO
	{
		private var _tableName : String = "";
		public function get tableName():String
		{
			return _tableName;
		} 
		public function set tableName( value:String ):void
		{
			_tableName = value;
		} 
		
		private var _exportVO : Boolean = false;
		public function get exportVO():Boolean
		{
			return _exportVO;
		} 
		public function set exportVO( value:Boolean ):void
		{
			_exportVO = value;
		} 
	
		private var _voNs : String = "";
		public function get voNamespace():String
		{
			return _voNs;
		} 
		public function set voNamespace( value:String ):void
		{
			_voNs = value;
		} 


		private var _exportDAO : Boolean = false;
		public function get exportDAO():Boolean
		{
			return _exportDAO;
		} 
		public function set exportDAO( value:Boolean ):void
		{
			_exportDAO = value;
		} 
		
		private var _daoName : String = "";
		public function get daoName():String
		{
			return _daoName;
		} 
		public function set daoName( value:String ):void
		{
			_daoName = value;
		} 

	}
}