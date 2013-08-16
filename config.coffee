sys = require('system')

# ============
# ==== EXPORTS

exports.args = sys.args;
exports.port = sys.args[1] || '8080'
exports.token = sys.args[2] || 'secret'