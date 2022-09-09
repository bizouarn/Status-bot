package status.services;

interface IStatus {
    private var message:String;
    private var emoji:String;

    public function setEmoji(emoji:String):Void;
    public function setMessage(emoji:String):Void;
    public function publishStatus():String;
}