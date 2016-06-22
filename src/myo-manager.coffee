_ = require 'lodash'
Myo = require 'myo'
{EventEmitter} = require 'events'

class MyoManager extends EventEmitter
  constructor: ->
    # hook for tests
    @Myo = Myo
    @Myo.on 'arm_synced', @_onArmSynced
    @Myo.on 'arm_unsynced', @_onArmUnsynced
    @Myo.on 'locked', @_onLocked
    @Myo.on 'unlocked', @_onUnlocked
    @Myo.on 'accelerometer', @_onAccelerometer
    @Myo.on 'gyroscope', @_onGyroscope
    @Myo.on 'orientation', @_onOrientation
    @Myo.on 'imu', @_onIMU
    @Myo.on 'emg', @_onEMG
    @Myo.on 'pose_off', @_onPoseOff
    @Myo.on 'rest', @_onRest
    @Myo.on 'warmup_completed', @_onWarmupCompleted

  close: (callback) =>
    @Myo.on 'disconnected', =>
      @myo = null
      @Myo.off 'disconnected'
      callback()
    try
      @Myo.disconnect()
    catch error
      callback()

  connect: (options, callback) =>
    {
      @interval
      @accelerometer
      @emg
      @imu
      @gyroscope
      @orientation
      @pose
    } = options
    @_emit = _.throttle @emit, @interval, {leading: true, trailing: false}
    that = @
    @Myo.on 'connected', ->
      that.myo = @
      that.Myo.off 'connected'
      @streamEMG?(@emg)
      callback()
    @close =>
      @Myo.connect 'com.octoblu.connector.myo'

  getBatteryLevel: (callback) =>
    return callback new Error 'Myo not connected' unless @myo
    @Myo.on 'battery_level', (batteryLevel) =>
      @Myo.off 'battery_level'
      callback null, {batteryLevel}

    @myo.requestBatteryLevel()

  getBluetoothStrength: (callback) =>
    return callback new Error 'Myo not connected' unless @myo
    @Myo.on 'rssi', (bluetoothStrength) =>
      @Myo.off 'rssi'
      callback null, {bluetoothStrength}

    @myo.requestBluetoothStrength()

  isOnline: (callback) =>
    callback null, running: !!@myo

  lock: (callback) =>
    return callback new Error 'Myo not connected' unless @myo
    @myo.lock()
    callback()

  _onArmSynced: =>
    return unless @pose
    @emit 'event', event: 'arm_synced'

  _onArmUnsynced: =>
    return unless @pose
    @_emit 'event', event: 'arm_unsynced'

  _onLocked: (data) =>
    return unless @pose
    @_emit 'event', event: 'locked'

  _onUnlocked: (data) =>
    return unless @pose
    @_emit 'event', event: 'unlocked'

  _onAccelerometer: (data) =>
    return unless @accelerometer
    @_emit 'event', {event: 'accelerometer', data}

  _onGyroscope: (data) =>
    return unless @gyroscope
    @_emit 'event', {event: 'gyroscope', data}

  _onOrientation: (data) =>
    return unless @orientation
    data =
      offset:
        w: data.w
        x: data.x
        y: data.y
        z: data.z

    @_emit 'event', {event: 'orientation', data}

  _onIMU: (data) =>
    return unless @imu
    @_emit 'event', {event: 'imu', data}

  _onEMG: (data) =>
    return unless @emg
    @_emit 'event', {event: 'emg', data}

  _onPoseOff: (poseNameOff) =>
    return unless @pose
    poseName = poseNameOff.replace('_off', '')
    @_emit 'event', event: poseName

  _onRest: =>
    return unless @pose
    @_emit 'event', event: 'rest'

  _onWarmupCompleted: =>
    return unless @pose
    @_emit 'event', event: 'warmup_completed'

  vibrate: ({intensity}, callback) =>
    return callback new Error 'Myo not connected' unless @myo
    @myo.vibrate intensity
    callback()

  unlock: ({timed}, callback) =>
    return callback new Error 'Myo not connected' unless @myo
    @myo.unlock timed
    callback()

  zeroOrientation: (callback) =>
    return callback new Error 'Myo not connected' unless @myo
    @myo.zeroOrientation()
    callback()

module.exports = MyoManager
