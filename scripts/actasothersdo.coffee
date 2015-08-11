# Description:
#   Send messages if a pattern is found in the conversation, such as salutations or ppl laughings
#
# Dependencies:
#   None
#
# Configuration:
#   See configs array
#
# Commands:
#   None
#

configs = [
  name: "laugh"
  hear: [/^jaja/i]
  respond: ["jajaj", "jajajja", "jajaja", "jojoy", 'ajajj q hdp', 'JAJAJA', 'JA!', ["jajaja", ":joy:"]]
  chances: .7
  expiration: 2 * 60 * 1000
,
  name: "hello"
  hear: [/^buenas[s\s]*$/i, /^buen(os)? d[ií]a(s)?$/i]
  respond: ["buenas", "hola, que tal?", ["buenas", "como va?"], ["holaa", "todo bien?"]]
  chances: 1
  expiration: 15 * 60 * 1000
,
  name: "bye"
  hear: [/^bueno(.)+me(\s)+voy/i, /^(bueno)?[\s,]*nos vemo(.)*/i, /^bye/i, /^cya$/i, /^abrazo[\s\S]{0,4}$/i]
  respond: ["nos vemos!", "nos vemooo", "goodbye", "chau chau", "adios", "abrazo", "abrazoooo", ["abrazo", "nos vemos"], "byes" ]
  chances: 1
  expiration: 15 * 60 * 1000
]

class Attitude
  @maxDelay: 15 * 1000

  constructor: (config, @robot) ->
    for key, value of config
      @[key] = value
    @setupHandler()

  setupHandler: () ->
    @robot.hear(hearing, (res) => @handler res) for hearing in @hear

  handler: (res) ->
    if Math.random() <= @chances and @shouldAct()
      @updateLastSent()
      @sendDelayedMessage(res, res.random(@respond))

  sendDelayedMessage: (res, message, delay = Math.random() * @constructor.maxDelay) ->
    if typeof(message) is "string"
      setTimeout () ->
        res.send message
      , delay
    else
      @sendDelayedMessage(res, msg, delay + i * Math.random() * 2000) for msg, i in message

  shouldAct: () ->
    data = AttitudeData.load @name
    isNotSpam = if data.lastSent? then (new Date - new Date(data.lastSent)) > @expiration else true
    isNotSpam

  updateLastSent: () ->
    data = AttitudeData.load @name
    data.lastSent = new Date
    data.save()

class AttitudeData
  @brain = null

  @getEmpty: (name) ->
    new AttitudeData
      name: name
      lastReceived: null
      lastSent: null
      countReceived: 0

  @load: (name) ->
    data = @brain.get("#{@name}:#{name}")
    if data? then new AttitudeData(data) else @getEmpty(name)

  constructor: ({@name, @lastReceived, @lastSent, @countReceived}) ->

  save: () ->
    @constructor.brain.set("#{@constructor.name}:#{@name}", this)


module.exports = (robot) ->
  AttitudeData.brain = robot.brain
  attitudes = new Attitude(config, robot) for config in configs
