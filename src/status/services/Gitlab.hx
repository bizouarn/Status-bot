package status.services;

class Gitlab implements IStatus{
    private var message:String;
    private var emoji:String;
    private var token:String;

    #if js
    public static var axios =  js.Syntax.code("require('axios')");
    #end
    public static var emojiJson:Map<String, Dynamic> = new Map<String, Dynamic>();

    public function new(token:String){
        var fs = js.Syntax.code("require('fs')");
        this.token = token;
        #if js
        var emojiJsonJ:Array<Dynamic> = js.Syntax.code("(JSON.parse(fs.readFileSync('./assets/emojiGitlab.json', 'utf8')))");
        #end
        for(emojiG in Reflect.fields(emojiJsonJ)){
            emojiJson.set(Reflect.field(emojiJsonJ, emojiG).moji, emojiG);
        }
    }

    public function setEmoji(emoji:String){
        if(!emojiJson[emoji]){
            this.emoji = 'computer';
        }else{
            this.emoji = emojiJson[emoji];
        }
        return false;
    }

    public function setMessage(message:String){
        this.message = message; 
        return true;
    }

    public function publishStatus(){
        #if js
        axios.put('https://gitlab.com/api/v4/user/status', {
            emoji: emoji,
            message: message
        }, {
            headers: {
                'PRIVATE-TOKEN': token
            }
        });
        return "";
        #else
        return "Gitlab publish TODO";
        #end
    }
}