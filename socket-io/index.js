var server = require('http').createServer()

server.listen(80)

require('./socket.io.init')(server)
