package status.services;

class Gitlab implements IStatus{
    private var message:String;
    private var emoji:String;

    public function new(){
        
    }

    public function setEmoji(emoji:String){
        return false;
    }

    public function setMessage(emoji:String){
        return false;
    }

    public function publishStatus(){
        return "TODO";
    }
}