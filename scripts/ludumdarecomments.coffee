# Description:
#   Responds with the latest comments for a ludum dare game.
#
# Dependencies:
#   "request": ""
#   "cheerio": ""
#
# Commands:
#   hubot ludum
request = require('request')
cheerio = require('cheerio')

ROOM_TO_MESSAGE = 'ludum'
LUDUM_URL = 'http://ludumdare.com/compo/ludum-dare-33/?action=preview&uid=31386'

module.exports = (robot) ->

  robot.on 'ludum', (diff) ->
    requestOptions =
      method: 'GET'
      url: LUDUM_URL
      headers:
        userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36'

    request requestOptions, (err, res, body) ->
      if err
        msg.send "Encountered an error :( #{err}"
        return
      $ = cheerio.load body
      seenCount = if diff then (parseInt(robot.brain.get('ludum'),10) or 0) else 0
      comments = $('div.comment p')
      if comments.length is seenCount
        robot.messageRoom ROOM_TO_MESSAGE, '_nada nuevo_'
        return
      comments.each (i) ->
        robot.messageRoom ROOM_TO_MESSAGE, $(this).text() + ':end:\n' if i >= seenCount
      robot.brain.set('ludum', comments.length)

  robot.respond /ludum$/i, (msg) ->
    robot.emit 'ludum', true

  robot.respond /ludum all$/i, (msg) ->
    robot.emit 'ludum', false

  robot.respond /ludum reset$/i, (msg) ->
    robot.brain.remove('ludum')
    msg.send 'He olvidado los comentarios leidos de ludum'
