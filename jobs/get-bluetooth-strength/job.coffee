http = require 'http'

class GetBluetoothStrength
  constructor: ({@connector}) ->
    throw new Error 'GetBluetoothStrength requires connector' unless @connector?

  do: (message, callback) =>
    @connector.getBluetoothStrength (error, {bluetoothStrength}) =>
      return callback error if error?
      metadata =
        code: 200
        status: http.STATUS_CODES[200]

      data = {bluetoothStrength}
      callback null, {metadata, data}

module.exports = GetBluetoothStrength
