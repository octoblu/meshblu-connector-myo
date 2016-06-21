http = require 'http'

class Lock
  constructor: ({@connector}) ->
    throw new Error 'Lock requires connector' unless @connector?

  do: (message, callback) =>
    @connector.lock callback

module.exports = Lock
