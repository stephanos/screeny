util = require('./util')
webpage = require('webpage')

# ============
# ==== EXPORTS

exports.renderHtml = (opts, callback) ->
  loadPage opts, (status, page) ->
    success = status is 'success'
    data =
      if success
        page.content
      else
        ''

    callback success, data

exports.renderImage = (opts, callback) ->
  loadPage opts, (status, page) ->
    success = status is 'success'
    data =
      if success
        {
          format: 'png'
          status: status
          data: renderPage page
        }
      else
        {
          status: status
        }

    callback success, JSON.stringify(data)


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

  timeout = opts.timeout || 3000 # default: 3s
  util.log 'loading web page: ' + url + ' (timeout: ' + timeout + 'ms)'

  page.open url, (status) ->
    window.setTimeout () ->
      callback status, page
    , timeout

renderPage = (page) ->
  data = page.renderBase64('PNG')
  util.log 'rendered screenshot: ' + data.length + ' bytes'
  data