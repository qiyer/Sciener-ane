package com.door.ane
{
	import flash.external.ExtensionContext;
	
	public class DoorInterface extends BaseInterface
	{
		private static const DOOR_AUTO:String = "ane_deal";
		private static const DOOR_INIT:String = "ane_init";
		private static const DOOR_CONNECT:String = "ane_connect";
		private static const DOOR_DISCONNECT:String = "ane_disconnect";
		private static const DOOR_OPEN:String = "ane_open";
		private static const DOOR_OPEN_TIME:String = "ane_open_time";
		private static const DOOR_ADMIN:String = "ane_open_admin";
		
		public function DoorInterface(_extContext:ExtensionContext)
		{
			super(_extContext);
		}
		
		public function initAutoSDK(openID:String,lockKey:String,aesKey:String,version:String,startDate:String = "0",endDate:String = "0",invalidFlag: int = 0):void{
			extContext.call(DOOR_AUTO,openID,lockKey,aesKey,version,startDate,endDate,invalidFlag);
		}
		
		public function initSDK(openID:String,lockKey:String,aesKey:String,version:String,startDate:String = "0",endDate:String = "0",invalidFlag: int = 0):void{
			extContext.call(DOOR_INIT,openID,lockKey,aesKey,version,startDate,endDate,invalidFlag);
		}
		
		public function initRefreshAutoSDK(openID:String,lockKey:String,aesKey:String,version:String,startDate:String = "0",endDate:String = "0",invalidFlag: int = 0,refreshDate:String = "0"):void{
			extContext.call(DOOR_OPEN_TIME,openID,lockKey,aesKey,version,startDate,endDate,invalidFlag,refreshDate);
		}
		
		public function initAdminAutoSDK(openID:String,admin:String ,lockKey:String,aesKey:String,version:String,invalidFlag: int = 0):void{
			extContext.call(DOOR_ADMIN,openID,admin,lockKey,aesKey,version,invalidFlag);
		}
		
		public function connect():void{
			extContext.call(DOOR_CONNECT);
		}
		
		public function disconnect():void{
			extContext.call(DOOR_DISCONNECT);
		}
		
		public function openDoor():void{
			extContext.call(DOOR_OPEN);
		}
	}
}