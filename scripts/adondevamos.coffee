# Description:
#   Returns a probability-based random place where to get drunk
#
# Commands:
#   hubot a donde vamos
#
# Dependencies:
#   "weighted": "~0.2.2"
#

weighted = require "weighted"

places =
  puerta: 0.4
  dubliners: 0.2
  rubik: 0.1
  alamo: 0.1
  cruzat: 0.1
  ninguno: 0.1

isSameDate = (a, b) ->
  a.getDate() is b.getDate() and
  a.getMonth() is b.getMonth() and
  a.getFullYear() is b.getFullYear()

module.exports = (robot) ->
  robot.respond /(a |a)?(donde|dónde) vamos$/i, (msg) ->
    place = robot.brain.get('adondevamos')
    if not place or not isSameDate(place.date, new Date)
      place =
        name: weighted.select places
        date: new Date
        owner: msg.message.user.name

    robot.brain.set 'adondevamos', place

    msg.send "Vamos a #{place.name} (lo preguntó #{place.owner} - #{place.date})'."
