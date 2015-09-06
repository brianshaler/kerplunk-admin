crypto = require 'crypto'

module.exports = (str) ->
  h = crypto.createHash 'sha1'
  h.update str
  h.digest 'hex'
