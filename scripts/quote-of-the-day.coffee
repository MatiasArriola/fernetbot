
mustache = require('mustache')
MarkovHook = require('./markov-hook.coffee')

TEMPLATE = """
<html>
  <head>
    <title>Frase del día | {{ robot.name }}</title>
    <style type="text/css">
      body {
        background-size: cover !important;
        height: 100%;
        margin: 0;
      }

      .container {
        position: absolute;
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
      }

      blockquote {
        padding: 20px;
        width: 100%;
        text-align: center;
        margin: auto;
        background-color: black;
        opacity: 0.8;
        color: white;
        font-size: 2em;
        font-family: Arial, Helvetica, sans-serif;
        font-style: oblique;
        box-shadow: 0px 10px 10px black,
           0px -10px 10px black;
      }

      blockquote p {
        display: inline-block;
        max-width: 620px;
      }

      blockquote p::after, blockquote p::before {
        content: ' " ';
      }
    </style>
  </head>
  <body>
    <div class="container">
      <blockquote>
        <p>
          {{ quote }}
        </p>
      </blockquote>
    </div>
    <script>
      document.body.style.background = "url('{{{ image }}}') no-repeat 50% 50% fixed";
    </script>
  </body>
</html>
"""

isSameDate = (a, b) ->
  a = new Date(a)
  b = new Date(b)

  a.getDate() is b.getDate() and
  a.getMonth() is b.getMonth() and
  a.getFullYear() is b.getFullYear()

getTodaysMessage = (robot, callback) =>
  message = robot.brain.get('messageoftheday')
  if not message or not isSameDate(message.date, new Date)
    MarkovHook.generate '', (text) =>
      imgMe robot, text, (image) =>
        message =
          quote: text
          image: image
          date: new Date
        robot.brain.set 'messageoftheday', message
        callback message
  else
    callback message

imgMe = (robot, text, callback) =>
  q = imgsz: 'large', v: '1.0', rsz: '8', q: text#, safe: 'active'
  robot.http('https://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image  = images[Math.floor(Math.random() * images.length)]
        callback "#{image.unescapedUrl}#.png"


module.exports = (robot) ->

  quote = "this is a funny quote!"
  image = "//i.imgur.com/f90lqLT.jpg"


  robot.router.get "/mensaje-del-dia", (req, res) ->
    getTodaysMessage robot, (message) =>
      res.send mustache.render(TEMPLATE,
        robot: robot
        quote: message.quote
        image: message.image
      )
