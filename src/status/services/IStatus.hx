package status.services;

interface IStatus {
    public function setEmoji(emoji:String):Bool;
    public function setMessage(message:String):Bool;
    public function publishStatus():String;
}