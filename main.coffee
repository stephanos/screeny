conf = require('./config')
server = require('./server')

# LAUNCH SERVER
server.create(conf.port, conf.token)