sys = require('system')

# ============
# ==== EXPORTS

exports.log = (msg) ->
  sys.stdout.writeLine(msg)