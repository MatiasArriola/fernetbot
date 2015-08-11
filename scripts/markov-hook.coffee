# Description:
#   Send messages if a pattern is found in the conversation, such as salutations or ppl laughings
#
# Dependencies:
#   "hubot-markov": ""
#
# Configuration:
#   See configs array
#
# Commands:
#   None
#
Url = require 'url'
Redis = require '../node_modules/hubot-markov/node_modules/redis'

MarkovModel = require '../node_modules/hubot-markov/src/model'
RedisStorage = require '../node_modules/hubot-markov/src/redis-storage'

module.exports = (robot) ->
  # Configure redis the same way that redis-brain does.
  info = Url.parse process.env.REDISTOGO_URL or
    process.env.REDISCLOUD_URL or
    process.env.BOXEN_REDIS_URL or
    process.env.REDIS_URL or
    'redis://localhost:6379'
  client = Redis.createClient(info.port, info.hostname)

  if info.auth
    client.auth info.auth.split(":")[1]

  storage = new RedisStorage(client)

  # Read markov-specific configuration from the environment.
  ply = process.env.HUBOT_MARKOV_PLY or 1
  min = process.env.HUBOT_MARKOV_LEARN_MIN or 1
  max = process.env.HUBOT_MARKOV_GENERATE_MAX or 50

  model = new MarkovModel(storage, ply, min)

  robot.respond /testloco$/i, (msg) ->
    robot.logger.info "matitest msg.message.room: #{msg.message.room}"
    robot.messageRoom "random", "testloco OK"

  robot.on 'markov', (room, seed) ->
    model.generate seed or '', max, (text) =>
      robot.messageRoom room or process.env.HUBOT_MARKOV_HOOK_ROOM, text
