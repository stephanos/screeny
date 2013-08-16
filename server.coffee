util = require('./util')
phantom = require('./phantom')
webpage = require('webpage')
webserver = require('webserver').create()

# ============
# ==== EXPORTS

exports.create = (port, token) ->
  util.log('initiating web server at :' + port)
  webserver.listen(port, (request, response) ->

    try
      url = request.url
      qry = qryVars(url)
      method = request.method
      headers = request.headers

      # check authorization
      auth = headers['Authorization'] || qry['auth'] || ''
      if (auth.indexOf(token) == -1)
        response.statusCode = 401
        response.write 'Unauthorized'
      else
        if (method == 'GET' && url.indexOf('/snap') == 0)
          phantom.render(qry, (data) ->
            POST qry['callback'], data
          )
          response.statusCode = 200
          response.write 'Okay'
        else
          response.statusCode = 404
          response.write 'Not Found'

        response.setHeader 'Authorization', 'Token ' + token
    catch error
      util.log error
      response.statusCode = 500
      response.write error

    response.close()
  )

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
      if (status != 'success')
        util.log 'POST ERROR: ' + page.content
