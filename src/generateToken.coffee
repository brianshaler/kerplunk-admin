hash = require './hash'

module.exports = (u, k) ->
  hash "#{u}|#{k}"
