package status.services;

class Github implements IStatus{
	var message:String;
	var emoji:String;
	var token:String;

	#if js
	public static var graphql = js.Lib.require('@octokit/graphql').graphql;
	public static var axios = js.Syntax.code("require('axios')");
	public var github:Dynamic;
	#end

	public function new(token:String){
		this.token = token;
	}

	public function setEmoji(emoji:String):Bool{
		if(!Gitlab.emojiJson[emoji]){
			this.emoji = ':computer:';
		}else{
			this.emoji = ':' + Gitlab.emojiJson[emoji] + ':';
		}
		return false;
	}

	public function setMessage(message:String):Bool{
		this.message = message;
		return true;
	}

	public function publishStatus():String{
		var auth:String = 'bearer '+token;
		var query:String = 'mutation{changeUserStatus(input:{emoji:"'+emoji+'",message:"'+message+'"}){status{message emoji}}}';
		#if js
		axios.post('https://api.github.com/graphql', {
			query : query
		}, {
			headers: {
				'Authorization': auth
			}
		});
		return "";
		#else
		return "Github publish TODO";
		#end
	}
}