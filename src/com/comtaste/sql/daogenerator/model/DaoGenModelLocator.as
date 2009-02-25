package com.comtaste.sql.daogenerator.model
{
	import flash.data.SQLConnection;
	import flash.data.SQLTableSchema;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	public class DaoGenModelLocator
	{
		private static var instance:DaoGenModelLocator;
		public static function getInstance():DaoGenModelLocator
		{
			if( instance == null )
				instance = new DaoGenModelLocator( new SingletonLock );
			return instance;
		}
		
		public function DaoGenModelLocator( lock:SingletonLock ) {}
		
		
/*************************************************************************
 * public API		
*************************************************************************/	
		
		public function getTableSchemaByName( name:String ):SQLTableSchema
		{
			if( availableTables == null || availableTables.length == 0 )
				return null;
			
			var tableSchema:SQLTableSchema;
			for each( tableSchema in availableTables )
			{
				if( tableSchema.name == name )
					break;
				tableSchema = null;
			}
			
			return tableSchema;
		}
		
/*************************************************************************
 * exposed properties		
*************************************************************************/	
		
		private var _lastOpenedCollection:ArrayCollection = new ArrayCollection();
		public function get lastOpenedCollection():ArrayCollection
		{
			return _lastOpenedCollection;
		}
		[Bindable]
		public function set lastOpenedCollection( value:ArrayCollection ):void
		{
			_lastOpenedCollection = value;
		}


		private var _currentFile:File;
		public function get currentFile():File
		{
			return _currentFile;
		}
		[Bindable]
		public function set currentFile( value:File ):void
		{
			_currentFile = value;
		}

		private var _destinationFolder:File;
		public function get destinationFolder():File
		{
			if( _destinationFolder == null )
			{
				_destinationFolder = File.userDirectory.resolvePath( "DaoGen" );
				_destinationFolder.createDirectory();
			}
			return _destinationFolder;
		}
		[Bindable]
		public function set destinationFolder( value:File ):void
		{
			_destinationFolder = value;
		}


		private var _sqlConnection:SQLConnection = new SQLConnection();
		public function getSqlConnection():SQLConnection
		{
			return _sqlConnection;
		}
		
		
		
		private var _availableTables:ArrayCollection = new ArrayCollection();
		public function get availableTables():ArrayCollection
		{
			return _availableTables;
		}
		[Bindable]
		public function set availableTables( value:ArrayCollection ):void
		{
			_availableTables = value;
		}


		private var _globalNamespaceVO:String = "";
		public function get globalNamespaceVO():String
		{
			return _globalNamespaceVO;
		}
		[Bindable]
		public function set globalNamespaceVO( value:String ):void
		{
			_globalNamespaceVO = value;
		}

		private var _globalNamespaceDAO:String = "";
		public function get globalNamespaceDAO():String
		{
			return _globalNamespaceDAO;
		}
		[Bindable]
		public function set globalNamespaceDAO( value:String ):void
		{
			_globalNamespaceDAO = value;
		}

	}
}

class SingletonLock {}