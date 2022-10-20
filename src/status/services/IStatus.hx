package status.services;

interface IStatus {
	function setEmoji(emoji:String):Bool;
	function setMessage(message:String):Bool;
	function publishStatus():String;
}