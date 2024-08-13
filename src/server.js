'use strict'

const server = require('./app')({
  logger: {
    level: 'info',
  },
})

const port = process.env.PORT || 3000

server.listen({ port: port, host: '0.0.0.0' }, (err, address) => {
  if (err) {
    server.log.error(err)
    process.exit(1)
  }
})
