const axios = require('axios')
const { graphql } = require('@octokit/graphql')
const fs = require('fs')
const { trace } = require('console')
// Read config file
const conf = JSON.parse(fs.readFileSync('./config.json', 'utf8'))
// TOKEN
const gitlabToken = conf.gitlabToken
const githubToken = conf.githubToken
// Initialize connections
const github = graphql.defaults({
    headers: {
        authorization: `token ${githubToken}`,
    },
})
// Get list of emojis
var emojisGitlab
var emojisGithub

// Listen to topic
async function publish(message) {
    var emoji = message.emoji
    var msg = message.msg

    try{
        if(emojisGitlab == undefined) emojisGitlab = await axios.get('https://raw.githubusercontent.com/bonusly/gemojione/master/config/index.json')
        if(emojisGithub == undefined) emojisGithub = await axios.get('https://api.github.com/emojis')
    }catch(error){
        console.log("get file:"+error.message)
    }

    for(var emojiG in emojisGitlab.data){
        if(emoji == emojisGitlab.data[emojiG].moji){
            emoji = emojiG
        }
    }

    try{
        // If emoji is null, set default emoji as :speech_balloon:
        if (emoji == null && msg != null) {
            emoji = 'speech_balloon'
        }

        // If emoji is in json at gitlab.com
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
        })
    } catch(error){
        console.log("gitlab:"+error.message)
    }

    try{
        // If emoji is in emojis and is not null
        if (!emojisGithub.data[emoji]) {
            emoji = ':computer:'
        } else {
            emoji = ':' + emoji + ':'
        }
        // Send post request to github server
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
                console.log(err)
            } else {
                console.log(res)
            }
        }
        })
    } catch (error) {
        console.log("github:"+error.message)
    }
}

function Main() {
    switch (new Date().getHours()) {
        case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:case 8:case 23:case 24:
            publish({
                emoji: '💤',
                msg: 'It\'s time to sleep'
            })
            break;
        case 9:case 11:case 14:case 15:case 16:
            // If day is sun_with_facedays or saturdays, set status to "It's time to chill"
            if (new Date().getDay() == 0 || new Date().getDay() == 6) {
                publish({
                    emoji: '🌞',
                    msg: 'It\'s time to chill'
                })
            } else {
            publish({
                emoji: '💻',
                msg: 'I\'m working on something'
            })
            }
            break;
        case 10:
            publish({
                emoji: '☕',
                msg: 'Coffee time'
            })
            break;
        case 12:case 13:
            publish({
                emoji: '🍔',
                msg: 'It\'s lunch time'
            })
            break;
        case 17:
            publish({
                emoji: '💾',
                msg: 'It\'s time to save'
            })
            break;
        case 18:case 19:case 20:case 21:case 22:
            publish({
                emoji: '🌞',
                msg: 'It\'s time to chill'
            })
            break;
        default:
            console.log(new Date().getHours())
    }
}

Main()
setInterval(Main, 300000)
