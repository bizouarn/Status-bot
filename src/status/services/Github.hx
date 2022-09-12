package status.services;

class Github implements IStatus{
    private var message:String;
    private var emoji:String;
    private var token:String;

    #if js
    public static var graphql = js.Lib.require('@octokit/graphql').graphql;
    public static var axios = js.Syntax.code("require('axios')");
    public var github:Dynamic; 
    #end

    public function new(token:String){
        trace((graphql:Any));
        /*github = new graphql({
            headers: {
                authorization: 'token ${token}',
            },
        });*/
    }

    public function setEmoji(emoji:String){
        if(!Gitlab.emojiJson[emoji]){
            this.emoji = ':computer:';
        }else{
            this.emoji = ':' + Gitlab.emojiJson[emoji] + ':';
        }
        return false;
    }

    public function setMessage(message:String){
        this.message = message; 
        return true;
    }

    public function publishStatus(){
        #if js
        /*axios.post('https://api.github.com/graphql', {query:`query{__schema}`} ,{
            headers: {
                'Authorization': "bear " + token,
                'Content-Type': 'application/json'
            }
        });
        js.Syntax.code("
        github(`mutation changeUserStatus ($input: ChangeUserStatusInput!) {
            changeUserStatus (input: $input) {
                status {
                    emoji
                    message
                }
            }
        }`, {
        input: {
            message: msg,
            emoji: (emoji)
        }
        })
        */
        return "";
        #else
        return "Github publish TODO";
        #end
    }
}