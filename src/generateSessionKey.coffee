hash = require './hash'

module.exports = (u, p) ->
  hash u + p + Date.now()
