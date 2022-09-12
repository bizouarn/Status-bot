package status.services;

interface IStatus {
    public function setEmoji(emoji:String):Bool;
    public function setMessage(emoji:String):Bool;
    public function publishStatus():String;
}