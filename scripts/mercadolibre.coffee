# Description:
#   Responds with the average price for a product in Mercadlibre.
#   (results may be off, depending on search terms and product)
# Commands:
#   hubot cuanto cuesta <query> - searches meli and return avg price

module.exports = (robot) ->

  robot.error (err, msg) ->
    #robot.messageRoom '#fernetbot-playground', 'ERROR:' + JSON.stringify(err)
    robot.logger.error JSON.stringify(err)
    robot.logger.error JSON.stringify(msg)

  robot.respond /(cuanto cuesta|cuanto vale)( un| el| la)? (.*)/i, (msg) ->
    calculateAverage = (rawResponse) ->
      data = JSON.parse(rawResponse)
      prices = data.results.map (r) -> r.price
      (prices.reduce (a,b) -> a + b) / prices.length

    getPopularPost = (rawResponse) ->
      data = JSON.parse(rawResponse)
      data.results.reduce (a,b) ->
        if a.sold_quantity > b.sold_quantity
          a
        else
          b

    query = msg.match[3]
    robot.logger.debug "Buscando #{query}"
    msg.http("https://api.mercadolibre.com")
      .header('accept', 'application/json')
      .header('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36')
      .path('sites/MLA/search')
      .query(q: query, limit: 2)
      # .get() (err, res, body) ->
      #   robot.logger.debug "Respuesta obtenida"
      #   if err
      #     msg.send "Encountered an error :( #{err}"
      #     return
      #   avg = Math.round calculateAverage(body)
      #   popularLink = getPopularPost(body).permalink
      #   msg.send  """
      #             El valor de _#{query}_ en promedio es de *$#{avg}*.
      #             La publicación más popular es #{popularLink}.
      #             """
      .get((err, req) ->
        req.addListener('response', (resp) ->
          resp.addListener('data', (chunk) ->
            robot.logger.debug(chunk.toString())
          )
          resp.addListener('error', (chunk) ->
            robot.logger.error(chunk.toString())
          )
        )
        req.addListener('error', (error) ->
          robot.logger.error(error)
        ))()