# Description:
#   Responds with the average price for a product in Mercadlibre.
#   (results may be off, depending on search terms and product)
# Commands:
#   hubot cuanto cuesta <query> - searches meli and return avg price

https = require('https');
https.globalAgent.options.secureProtocol = 'SSLv3_method';
request = require('request')

module.exports = (robot) ->

  robot.respond /(cuanto cuesta|cuanto vale)( un| el| la)? (.*)/i, (msg) ->

    calculateAverage = (data) ->
      prices = data.results.map (r) -> r.price
      (prices.reduce (a,b) -> a + b) / prices.length

    getPopularPost = (data) ->
      data.results.reduce (a,b) ->
        if a.sold_quantity > b.sold_quantity
          a
        else
          b

    query = msg.match[3]

    requestOptions =
      method: 'GET'
      url: "https://api.mercadolibre.com/sites/MLA/search"
      qs:
        q: query
      headers: 
        userAgent: 'fernetbot 0.1'
      json: true

    request requestOptions, (err, res, body) ->
      if err
        msg.send "Encountered an error :( #{err}"
        return
      avg = Math.round calculateAverage(body)
      popularLink = getPopularPost(body).permalink
      msg.send  """
                El valor de _#{query}_ en promedio es de *$#{avg}*.
                La publicación más popular es #{popularLink}.
                """