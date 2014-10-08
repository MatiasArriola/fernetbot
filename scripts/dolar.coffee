# Description:
#   Responds with the ARS currency exchange for USD .
# 
# Commands:
#   hubot dolar blue - returns current 'informal' exchange
request = require('request')

module.exports = (robot) ->

  robot.respond /(dolar blue)/i, (msg) ->

    requestOptions =
      method: 'GET'
      url: "http://contenidos.lanacion.com.ar/json/dolar"
      headers: 
        userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.146 Safari/537.36'

    request requestOptions, (err, res, body) ->
      if err
        msg.send "Encountered an error :( #{err}"
        return
      data = JSON.parse(/\(([^)]+)\)/.exec(body)[1])
      msg.send  """
                Compra: $#{data.InformalCompraValue}.
                Venta: $#{data.InformalVentaValue}
                """