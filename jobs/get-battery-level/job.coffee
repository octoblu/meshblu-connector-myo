http = require 'http'

class GetBatteryLevel
  constructor: ({@connector}) ->
    throw new Error 'GetBatteryLevel requires connector' unless @connector?

  do: (message, callback) =>
    @connector.getBatteryLevel (error, {batteryLevel}) =>
      return callback error if error?
      metadata =
        code: 200
        status: http.STATUS_CODES[200]

      data = {batteryLevel}
      callback null, {metadata, data}

module.exports = GetBatteryLevel
