const axios = require('axios')
const { graphql } = require('@octokit/graphql');
const fs = require('fs');
// Read config file
const conf = JSON.parse(fs.readFileSync('./config.json', 'utf8'));
// TOKEN
const gitlabToken = conf.gitlabToken;
const githubToken = conf.githubToken;
// Iinitialize connections
const github = graphql.defaults({
    headers: {
        authorization: `token ${githubToken}`,
    },
});
// get list of emojis
var emojisGitlab;
var emojisGithub;

// listen to topic
async function publish(message) {
    var emoji = message.emoji;
    var msg = message.msg;
    try{
        if(emojisGitlab == undefined) emojisGitlab = await axios.get('https://raw.githubusercontent.com/bonusly/gemojione/master/config/index.json');
        if(emojisGithub == undefined) emojisGithub = await axios.get('https://api.github.com/emojis');
        }catch(error){
            console.log("get file:"+error.message)
        }
        try{
        // if emoji is null, set default emoji as :speech_balloon:
        if (emoji == null && msg != null) {
            emoji = 'speech_balloon'
        }

        // if emoji is in json at gitlab.com
        if(!emojisGitlab.data[emoji]){
            emoji = 'computer'
        }
        // send post request to gitlab server
        axios.put('https://gitlab.com/api/v4/user/status', {
            emoji: emoji,
            message: msg
        }, {
            headers: {
                'PRIVATE-TOKEN': gitlabToken
            }
        }).then(function (response) {
            console.log(response.data)
        }).catch(function (error) {
            console.log(error)
        }
        )
    } catch(error){
        console.log("gitlab:"+error.message)
    }
    try{
        // if emoji is in emojis and is not null
        if (!emojisGithub.data[emoji]) {
            emoji = ':computer:';
        } else {
            emoji = ':' + emoji + ':';
        }
        // send post request to github server
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
        }, function (err, res) {
            if (err) {
            console.log(err);
            } else {
            console.log(res);
            }
        }
        });
    } catch (error) {
        console.log("github:"+error.message)
    }
}
// listen to time event every hour
var CronJob = require('cron').CronJob;
// every hour
new CronJob('*/5 * * * *', function () {
    // if day is sun_with_facedays or saturdays, set status to "It's time to chill"
    // case hour
    switch (new Date().getHours()) {
        case 0, 1, 2, 3, 4, 5, 6, 7, 8, 23, 24:
            publish({
                emoji: ':sleeping:',
                msg: 'It\'s time to sleep'
            })
            break;
        case 9, 11, 14, 15, 16:
            if (new Date().getDay() == 0 || new Date().getDay() == 6) {
                publish({
                    emoji: 'sun_with_face',
                    msg: 'It\'s time to chill'
                })
            } else {
            publish({
                emoji: 'computer',
                msg: 'I\'m working on something'
            })
            }
            break;
        case 10:
            publish({
                emoji: 'coffee',
                msg: 'Coffee time'
            })
            break;
        case 12, 13:
            publish({
                emoji: 'hamburger',
                msg: 'It\'s lunch time'
            })
            break;
        case 17:
            publish({
                emoji: 'floppy_disk',
                msg: 'It\'s time to save'
            })
            break;
        case 2:
            publish({
                emoji: 'sun_with_face',
                msg: 'It\'s time to chill'
            })
            break;
    }
}, null, true, 'Europe/Paris');

publish({
    emoji: 'robot',
    msg: 'Bot is login'
})