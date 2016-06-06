{EventEmitter}  = require 'events'
debug           = require('debug')('meshblu-connector-myo:index')
_               = require('lodash')
Myo             = require('myo')

class MyoConnector extends EventEmitter
  constructor: ->
    isMyoConnected = false
    DEFAULT_OPTIONS =
      id: 0
      interval: 500
      accelerometer: enabled: false
      imu: enabled: false
      gyroscope: enabled: false
      orientation: enabled: false
    debug 'Myo constructed'

  onMessage: (message) =>
    debug 'got message', message
    { payload } = message
    return unless payload?
    if Myo.myos
      if payload.command and payload.command.action
        action = payload.command.action
        if action == 'vibrate'
          Myo.vibrate payload.command.vibrationLength
        else if action == 'requestBluetoothStrength'
          Myo.requestBluetoothStrength()
        else if action == 'zeroOrientation'
          Myo.zeroOrientation()

  onConfig: (device) =>
    { @options } = device
    @options = _.extend({}, @DEFAULT_OPTIONS, @options)
    @setupMyo()

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid
    @onConfig device

  setupMyo: =>
    debug 'setting up myo'
    myoId = @options.id or 0
    Myo.defaults =
      api_version: 3
      socket_url: 'ws://127.0.0.1:10138/myo/'
      app_id: 'com.octoblu.myo'
    debug 'creating myo with', myoId, Myo.defaults
    Myo.connect Myo.defaults.app_id
    if !@isMyoConnected
      @isMyoConnected = true
      @myoEvents()

  myoEvents: =>
    throttledEmit = _.throttle(((payload) ->
      debug 'throttled', payload
      @emit 'message',
        'devices': [ '*' ]
        'payload': payload
    ), @options.interval, 'leading': false)

    Myo.on 'connected', (data) ->
      @_myo = data
      debug 'We are connected to Myo, ', data
      @unlock()
      throttledEmit 'event': 'connected'

    Myo.on 'disconnected', ->
      debug 'We are disconnected from Myo'
      throttledEmit 'event': 'disconnected'

    Myo.on 'arm_synced', ->
      debug 'Arm Synced'
      throttledEmit 'event': 'arm_synced'

    Myo.on 'arm_unsynced', ->
      debug 'Arm arm_unsynced'
      throttledEmit 'event': 'arm_unsynced'

    Myo.on 'locked', (data) ->
      debug 'Locked Myo'
      throttledEmit 'event': 'locked'

    Myo.on 'unlocked', (data) ->
      debug 'Unlocked Myo'
      throttledEmit 'event': 'unlocked'

    Myo.on 'accelerometer', (data) ->
      throttledEmit 'accelerometer': data if @options.accelerometer.enabled

    Myo.on 'gyroscope', (data) ->
      throttledEmit 'gyroscope': data if @options.gyroscope.enabled

    Myo.on 'orientation', (data) ->
      data =
        offset:
          w: data.w
          x: data.x
          y: data.y
          z: data.z

      throttledEmit 'orientation': data if @options.orientation.enabled

    Myo.on 'imu', (data) ->
      throttledEmit 'imu': data if @options.imu.enabled

    Myo.on 'pose_off', (poseNameOff) ->
      @unlock()
      poseName = poseNameOff.replace('_off', '')
      debug 'event', poseName
      throttledEmit 'event': poseName

    Myo.on 'rssi', (val) ->
      throttledEmit 'bluetoothStrength': val

    Myo.on 'battery_level', (val) ->
      throttledEmit 'batteryLevel': val



module.exports = MyoConnector
