http = require 'http'

class Vibrate
  constructor: ({@connector}) ->
    throw new Error 'Vibrate requires connector' unless @connector?

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.intensity is required') unless data?.intensity?
    {intensity} = data

    @connector.vibrate {intensity}, callback

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = Vibrate
