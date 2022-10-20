package status.services;

class StatusObj{
	public var msg:String;
	public var emoji:String;

	public function new(emoji:String, msg:String){
		this.msg = msg;
		this.emoji = emoji;
	}
}