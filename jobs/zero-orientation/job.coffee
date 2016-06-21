http = require 'http'

class ZeroOrientation
  constructor: ({@connector}) ->
    throw new Error 'ZeroOrientation requires connector' unless @connector?

  do: (message, callback) =>
    @connector.zeroOrientation callback

module.exports = ZeroOrientation
