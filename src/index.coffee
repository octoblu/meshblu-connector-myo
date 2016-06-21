{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-myo:index')
MyoManager      = require './myo-manager'

class Connector extends EventEmitter
  constructor: ->
    @myo = new MyoManager

  isOnline: (callback) =>
    callback null, running: true

  close: (callback) =>
    debug 'on close'
    callback()

  getBatteryLevel: (callback) =>
    @myo.getBatteryLevel callback

  getBluetoothStrength: (callback) =>
    @myo.getBluetoothStrength callback

  lock: (callback) =>
    @myo.lock callback

  onConfig: (device={}, callback=->) =>
    { @options, events } = device
    debug 'on config', @options
    { interval } = @options ? {}
    { accelerometer, emg, imu, gyroscope, orientation, pose } = events ? {}
    @myo.connect { interval, accelerometer, emg, imu, gyroscope, orientation, pose }, callback

  start: (device, callback) =>
    debug 'started'
    @onConfig device, callback

  vibrate: ({intensity}, callback) =>
    @myo.vibrate {intensity}, callback

  unlock: ({timed}, callback) =>
    @myo.unlock {timed}, callback

  zeroOrientation: (callback) =>
    @myo.zeroOrientation callback

module.exports = Connector
