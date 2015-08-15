# fernetbot

Esta es la instancia de hubot que usamos en el slack de codigorutero.

Disclaimer: _Está armado todo así nomás como para que sea práctico y divertido antes que políticamente correcto._

Para saber más sobre hubot:  
  * [hubot](https://hubot.github.com/)
  * [Automation and Monitoring with Hubot](https://leanpub.com/automation-and-monitoring-with-hubot/read)
  * [hubot scripts](https://github.com/github/hubot-scripts) (ahora se usan packages con el tag [hubot-scripts en npm](https://www.npmjs.com/browse/keyword/hubot-scripts))


## Consideraciones
  * Necesita redis
  * En la carpeta `/scripts` se incluyen scripts que "vinieron" al correr el yeoman generator de hubot, así como también scripts propios de fernetbot que podrían pertenecer a su propio repo/npm package.
  * Probar con el shell adapter corriendo `bin/hubot`
