package status;

import status.config.Config;
import status.services.*;

class Main{
    private static var _services:Array<IStatus> = [];
    private static var _message:Map<String,StatusObj> = new Map();

    static public function main():Void {
        #if js
        js.Syntax.code("const fs = require('fs')");
        #end
        #if js
        var config:Config = js.Syntax.code("JSON.parse(fs.readFileSync('./config.json', 'utf8'))");
        #else
        var config:Config = haxe.Json.parse(sys.FileSystem.getContent("./config.json"));
        #end
        for(msg in config.Message){
            for(msgP in Reflect.fields(msg)){
                _message.set(msgP,new StatusObj(msgP,Reflect.field(msg, msgP)));
            }
        }

        if(config.GitlabToken.length > 0){
            Main._services.push(new Gitlab(config.GitlabToken));
        }
        if(config.GithubToken.length > 0){
            Main._services.push(new Github(config.GithubToken));
        }

        var timer = new haxe.Timer(config.RefreshTime); // 1000ms delay
        timer.run = function() {
            var date = Date.now();
            var hour = date.getHours();
            var day = date.getDay() - 1;
            if(day < 0) day = 6;
            var msgDay = config.Agenda[hour];
            if(msgDay.length == 1){
                publish(_message[msgDay[0]]);
            } else {
                publish(_message[msgDay[day]]);
            }
        }
        timer.run();
    }

    static function publish(obj:StatusObj){
        trace(obj);
        for(s in Main._services){
            s.setMessage(obj.msg);
            s.setEmoji(obj.emoji);
        }
    }
}
