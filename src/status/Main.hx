package status;

import status.services.Gitlab;

class Main{
    static public function main():Void {
        var timer = new haxe.Timer(1000); // 1000ms delay
        timer.run = function() {
            var date = Date.now();
            trace(date.getHours(), "+" + date.getTimezoneOffset());
            switch (date.getHours() + date.getTimezoneOffset()) {
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
    }

    static function publish(obj:Any){
        trace(obj);
    }
}
