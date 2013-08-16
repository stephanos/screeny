util = require('./util')
webpage = require('webpage')

# ============
# ==== EXPORTS

exports.render = (opts, callback) ->
  loadPage opts, (status, page) ->
    data =
      if status is 'success'
        {
          status: status
          format: 'png'
          data: renderPage page
        }
      else
        {
          status: status
        }

    callback JSON.stringify(data)


# ============
# ==== HELPERS

loadPage = (opts, callback) ->
  url = opts.url
  screenSize =
    width: opts.width || 1024
    height: opts.height || 768

  page = webpage.create()
  page.viewportSize = screenSize
  page.clipRect = { top: 0, left: 0, width: screenSize.width, height: screenSize.height }

  ###
  page.onAlert = (msg) ->
    console.log msg

  page.onError = (msg, trace) ->
    console.log msg
    trace.forEach (item) -> console.log '  ', item.file, ':', item.line
  ###

  util.log 'loading web page: ' + url
  page.open url, (status) ->
    callback status, page

renderPage = (page) ->
  data = page.renderBase64('PNG')
  util.log 'rendered screenshot: ' + data.length + ' bytes'
  data