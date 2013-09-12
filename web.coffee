util = require('./util')
phantom = require('./phantom')
webpage = require('webpage')
webserver = require('webserver').create()

# ============
# ==== EXPORTS

exports.create = (port, token) ->
  util.log('initiating web server at :' + port)
  webserver.listen port, (request, response) ->
    try
      url = request.url
      qry = qryVars(url)
      method = request.method
      headers = request.headers

      # check authorization
      auth = headers['Authorization'] || qry['auth'] || ''
      if auth.indexOf(token) == -1
        response.statusCode = 401
        response.write 'Unauthorized'
        return

      postback = qry['postback']
      reply = (success, data) ->
        status = if success then 200 else 500
        if postback # async
          if data
            POST postback, data # callback reply
          else
            response.statusCode = status
            response.write 'Okay' # defer reply
        else if data
          response.statusCode = status
          response.write data # reply sync

      # GET /image
      if method == 'GET' && url.indexOf('/image') == 0
        phantom.render qry, reply
        reply true

      # GET /html
      else if method == 'GET' && url.indexOf('/html') == 0
        phantom.render qry, reply
        reply true

      else
        response.statusCode = 404
        response.write 'Not Found'

      response.setHeader 'Authorization', 'Token ' + token

    catch error
      util.log error
      response.statusCode = 500
      response.write error

    response.close()

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
    page = webpage.create()
    util.log 'POST to: ' + url
    page.open url, 'post', data, (status) ->
      if status != 'success'
        util.log 'POST ERROR: ' + page.content
