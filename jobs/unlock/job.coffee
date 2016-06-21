http = require 'http'

class Unlock
  constructor: ({@connector}) ->
    throw new Error 'Unlock requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.timed is required') unless data?.timed?
    {timed} = data

    @connector.unlock {timed}, callback

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = Unlock
