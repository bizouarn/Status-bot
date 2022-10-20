package status.services;

class Gitlab implements IStatus{
	var message:String;
	var emoji:String;
	var token:String;

	#if js
	public static var axios =  js.Syntax.code("require('axios')");
	#end
	public static var emojiJson:Map<String, Dynamic> = new Map<String, Dynamic>();

	public function new(token:String){
		this.token = token;
		#if js
		var fs = js.Syntax.code("require('fs')");
		var emojiJsonJ:Array<Dynamic> = js.Syntax.code("(JSON.parse(fs.readFileSync('./assets/emojiGitlab.json', 'utf8')))");
		#else
		// TODO: add emojiJson for other platforms
		var emojiJsonJ:Array<Dynamic> = [];
		#end
		for(emojiG in Reflect.fields(emojiJsonJ)){
			emojiJson.set(Reflect.field(emojiJsonJ, emojiG).moji, emojiG);
		}
	}

	public function setEmoji(emoji:String):Bool{
		if(!emojiJson[emoji]){
			this.emoji = 'computer';
		}else{
			this.emoji = emojiJson[emoji];
		}
		return false;
	}

	public function setMessage(message:String):Bool{
		this.message = message;
		return true;
	}

	public function publishStatus():String{
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