# Description:
#   Roll a random number represented in nyancat icons.
#   (you need :nyan: and :nyancat: icons)
# Commands:
#   hubot nyanroll - rolls the nyan

module.exports = (robot) ->
  robot.respond /NYANROLL$/i, (msg) ->
    min = 0
    max = 12
    length = Math.floor(Math.random() * (max / 2)) * 2
    nyanarray = [0..length].map (x) -> 
      if(x == length)
        ":nyancat:"
      else
         ":nyan:"
    msg.send nyanarray.join('')
