{EventEmitter}  = require 'events'
_               = require('lodash')
Myo             = require('myo')
debug           = require('debug')('meshblu-connector-myo:index')

class MyoConnector extends EventEmitter
  constructor: ->
    @connecting = false
    @DEFAULT_EVENTS =
      accelerometer:
        enabled: false
      imu:
        enabled: false
      gyroscope:
        enabled: false
      orientation:
        enabled: false

  isOnline: (callback) =>
    callback null, running: !!@_myo

  onMessage: (message={}) =>
    debug 'got message', message
    { payload } = message
    return console.error 'no payload' unless payload?
    return console.error 'myo not connected' unless @isMyoConnected
    return console.error 'no myos' unless Myo.myos?
    { command, action } = payload
    return debug 'invalid command' unless command?
    return debug 'invalid action' unless Myo[action]?
    options = null
    options = command.vibrationLength if action == 'vibrate'
    Myo[action] options

  onConfig: (device={}) =>
    { options, events } = device
    { interval } = options ? {}
    @events = _.assign({}, @DEFAULT_EVENTS, events)
    @throttledEmit = _.throttle @emitEvent, interval ? 500, { 'leading': false }
    @setupMyo()

  emitError: (error) =>
    debug 'emit event', payload
    @emit 'message',
      'devices': [ '*' ]
      'topic': 'error',
      'payload': { error }

  emitEvent: (payload={}) =>
    debug 'emit event', payload
    @emit 'message',
      'devices': [ '*' ]
      'topic': 'event',
      'payload': payload

  start: (device) =>
    { @uuid } = device
    debug 'started', @uuid
    @onConfig device

  setupMyo: =>
    return if @connecting
    @connecting = true
    debug 'setting up myo'
    Myo.defaults =
      api_version: 3
      socket_url: 'ws://127.0.0.1:10138/myo/'
      app_id: 'com.octoblu.myo'
    debug 'connecting myo', Myo.defaults
    try
      Myo.connect Myo.defaults.app_id
    catch error
      @connecting = false
      console.error error
      @emitError error
      return
    return if @_myo
    @myoEvents()

  logEvent: (eventName, data) =>
    return unless @events[eventName].enabled
    @throttledEmit eventName: data

  myoEvents: =>
    Myo.on 'connected', (data) =>
      @connecting = false
      @_myo = data
      Myo.methods.unlock()
      debug 'We are connected to Myo, ', @_myo
      @throttledEmit 'event': 'connected'

    Myo.on 'disconnected', =>
      debug 'We are disconnected from Myo'
      @throttledEmit 'event': 'disconnected'

    Myo.on 'arm_synced', =>
      debug 'Arm Synced'
      @throttledEmit 'event': 'arm_synced'

    Myo.on 'arm_unsynced', =>
      debug 'Arm arm_unsynced'
      @throttledEmit 'event': 'arm_unsynced'

    Myo.on 'locked', (data) =>
      debug 'Locked Myo'
      @throttledEmit 'event': 'locked'

    Myo.on 'unlocked', (data) =>
      debug 'Unlocked Myo'
      @throttledEmit 'event': 'unlocked'

    Myo.on 'accelerometer', (data) =>
      @logEvent 'accelerometer', data

    Myo.on 'gyroscope', (data) =>
      @logEvent 'gyroscope', data

    Myo.on 'orientation', (data) =>
      data =
        offset:
          w: data.w
          x: data.x
          y: data.y
          z: data.z

      @logEvent 'orientation', data

    Myo.on 'imu', (data) =>
      @logEvent 'imu', data

    Myo.on 'pose_off', (poseNameOff) =>
      Myo.methods.unlock()
      poseName = poseNameOff.replace('_off', '')
      debug 'event', poseName
      @throttledEmit 'event': poseName

    Myo.on 'rssi', (val) =>
      @throttledEmit 'bluetoothStrength': val

    Myo.on 'battery_level', (val) =>
      @throttledEmit 'batteryLevel': val

module.exports = MyoConnector
