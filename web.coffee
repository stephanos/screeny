util = require('./util')
phantom = require('./phantom')
webpage = require('webpage')
webserver = require('webserver').create()

conf = require('./config')
port = conf.port
token = conf.token

# ============
# ==== EXPORTS

exports.create = ->
  util.log('initiating web server at port ' + port)
  webserver.listen port, (request, response) ->
    reply = (status, content) ->
      response.statusCode = status
      response.write content
      response.close()

    try
      url = request.url
      qry = qryVars(url)
      method = request.method
      headers = request.headers

      # check authorization
      auth = headers['Authorization'] || qry['auth'] || ''
      if auth.indexOf(token) == -1
        reply 401, 'Just what do you think you\'re doing, Dave?'
        return

      postback = qry['postback'] || ''
      util.log postback
      replyData = (success, data) ->
        status = if success then 200 else 500
        if postback != ''
          POST postback, data # reply async
        else
          reply status, data # reply sync


      # GET /image
      if method == 'GET' && url.indexOf('/image') == 0
        phantom.renderImage qry, replyData
        if postback != ''
          reply status, 'Okay'

      # GET /html
      else if method == 'GET' && url.indexOf('/html') == 0
        phantom.renderHtml qry, replyData
        if postback != ''
          reply status, 'Okay'

      else
        reply 404, 'Not Found'

    catch error
      util.log error
      reply 500, error

# ============
# ==== HELPERS

qryVars = (url) ->
  res = {}
  vars = url.replace(/^.*\?/, '').split('&')
  for i of vars
    pair = vars[i].split('=')
    res[pair[0]] = decodeURIComponent pair[1]
  res

POST = (url, data) ->
  if url
    #response.setHeader 'Authorization', 'Token ' + token
    page = webpage.create()
    util.log 'POST to: ' + url
    page.open url, 'post', data, (status) ->
      if status != 'success'
        util.log 'POST ERROR: ' + page.content
