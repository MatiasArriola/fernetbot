# Description:
#   Responds with the latest comments for a ludum dare game.
#
# Dependencies:
#   "request": ""
#   "cheerio": ""
#
# Commands:
#   hubot ludum - return new comments on the entry
#   hubot ludum all - return all the comments for the entry
#   hubot ludum reset - forgets about the read comments
#
request = require('request')
cheerio = require('cheerio')

ROOM_TO_MESSAGE = 'ludum'
LUDUM_URL = 'https://api.ldjam.com/vx/note/get/35653' 

module.exports = (robot) ->

  robot.on 'ludum', (diff) ->
    robot.http(LUDUM_URL)
    .header('Accept', 'application/json')
    .get() (err, res, body) ->
      if err
        msg.send "Encountered an error :( #{err}"
        return
      
      seenCount = if diff then (parseInt(robot.brain.get('ludum'),10) or 0) else 0
      data = JSON.parse body
      if data.note.length is seenCount
        robot.messageRoom ROOM_TO_MESSAGE, '_nada nuevo_'
        return
      data.note.each (i) ->
        robot.messageRoom ROOM_TO_MESSAGE, this.body + ':end:\n' if i >= seenCount
      robot.brain.set('ludum', comments.length)

  robot.respond /ludum$/i, (msg) ->
    robot.emit 'ludum', true

  robot.respond /ludum all$/i, (msg) ->
    robot.emit 'ludum', false

  robot.respond /ludum reset$/i, (msg) ->
    robot.brain.remove('ludum')
    msg.send 'He olvidado los comentarios leidos de ludum'
