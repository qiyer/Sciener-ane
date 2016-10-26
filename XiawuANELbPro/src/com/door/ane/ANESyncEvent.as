package com.door.ane
{
	import flash.events.Event;
	
	public class ANESyncEvent extends Event
	{
		public static const ANE_SYSC_EVENT:String = "ane_sysc_event";
		public function ANESyncEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public var code:String;
		public var level:String;
	}
}