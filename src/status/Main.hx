package status;

import status.config.Config;
import status.services.*;

class Main{
    private static var _services:Array<IStatus> = [];

    static public function main():Void {
        #if js
        js.Syntax.code("const fs = require('fs')");
        #end
        #if js
        var config:Config = js.Syntax.code("JSON.parse(fs.readFileSync('./config.json', 'utf8'))");
        #else
        var config:Config = haxe.Json.parse(sys.FileSystem.getContent("./config.json"));
        #end

        if(config.GitlabToken.length > 0){
            Main._services.push(new Gitlab(config.GitlabToken));
        }
        if(config.GithubToken.length > 0){
            Main._services.push(new Github(config.GithubToken));
        }

        var timer = new haxe.Timer(config.RefreshTime); // 1000ms delay
        timer.run = function() {
            var date = Date.now();
            trace("hour",date.getHours());
            switch (date.getHours()) {
                case 0, 1, 2, 3, 4, 5, 6, 7, 8, 23, 24:
                    publish({
                        emoji: '💤',
                        msg: 'It\'s time to sleep'
                    });
                case 9, 11, 14, 15, 16:
                    // If day is sun_with_facedays or saturdays, set status to "It's time to chill"
                    if (date.getDay() == 0 || date.getDay() == 6) {
                        publish({
                            emoji: '🌞',
                            msg: 'It\'s time to chill'
                        });
                    } else {
                        publish({
                            emoji: '💻',
                            msg: 'I\'m working on something'
                        });
                    }
                case 10:
                    publish({
                        emoji: '☕',
                        msg: 'Coffee time'
                    });
                case 12, 13:
                    publish({
                        emoji: '🍔',
                        msg: 'It\'s lunch time'
                    });
                case 17:
                    publish({
                        emoji: '💾',
                        msg: 'It\'s time to save'
                    });
                case 18, 19, 20, 21, 22:
                    publish({
                        emoji: '🌞',
                        msg: 'It\'s time to chill'
                    });
                default:
                    trace("No status");
            }
        }
        timer.run();
    }

    static function publish(obj:Any){
        var sm:StatusObj = obj;
        for(s in Main._services){
            s.setMessage(sm.msg);
            s.setEmoji(sm.emoji);
            trace(s.publishStatus());
        }
        trace(obj);
    }
}
