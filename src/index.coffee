{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-myo:index')
MyoManager      = require './myo-manager'

class Connector extends EventEmitter
  constructor: ->
    @myo = new MyoManager

  isOnline: (callback) =>
    @myo.isOnline (error, {running}) =>
      callback error, {running}

  close: (callback) =>
    callback()

  getBatteryLevel: (callback) =>
    @myo.getBatteryLevel callback

  getBluetoothStrength: (callback) =>
    @myo.getBluetoothStrength callback

  lock: (callback) =>
    @myo.lock callback

  onConfig: (device={}, callback=->) =>
    { @options, events } = device
    { interval } = @options ? {}
    { accelerometer, emg, imu, gyroscope, orientation, pose } = events ? {}
    @myo.connect { interval, accelerometer, emg, imu, gyroscope, orientation, pose }, callback

  start: (device, callback) =>
    @onConfig device, callback

  vibrate: ({intensity}, callback) =>
    @myo.vibrate {intensity}, callback

  unlock: ({timed}, callback) =>
    @myo.unlock {timed}, callback

  zeroOrientation: (callback) =>
    @myo.zeroOrientation callback

module.exports = Connector
