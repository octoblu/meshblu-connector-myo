MyoManager = require '../src/myo-manager'

describe 'MyoManager', ->
  beforeEach (done) ->
    @sut = new MyoManager
    {@Myo} = @sut
    @myo =
      streamEMG: sinon.stub()
      vibrate: sinon.stub()
      zeroOrientation: sinon.stub()
      unlock: sinon.stub()
      lock: sinon.stub()
      requestBatteryLevel: =>
        @Myo.trigger 'battery_level', 2
      requestBluetoothStrength: =>
        @Myo.trigger 'rssi', 2
    @Myo.connect = =>
      @Myo.trigger 'connected', @myo
    @Myo.disconnect = =>
      @Myo.trigger 'disconnected'

    options =
      accelerometer: true
      pose: true
      gyroscope: true
      orientation: true
      imu: true
      emg: true
      interval: 500
    @sut.connect options, done

  afterEach (done) ->
    @sut.close done

  it 'should call streamEMG', ->
    expect(@myo.streamEMG).to.have.been.calledWith true

  describe '->on arm_synced', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      @Myo.trigger 'arm_synced'

    it 'should set data', ->
      expect(@data).to.deep.equal event: 'arm_synced'

  describe '->on arm_unsynced', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      @Myo.trigger 'arm_unsynced'

    it 'should set data', ->
      expect(@data).to.deep.equal event: 'arm_unsynced'

  describe '->on arm_unsynced', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      @Myo.trigger 'arm_unsynced'

    it 'should set data', ->
      expect(@data).to.deep.equal event: 'arm_unsynced'

  describe '->on locked', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      @Myo.trigger 'locked'

    it 'should set data', ->
      expect(@data).to.deep.equal event: 'locked'

  describe '->on unlocked', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      @Myo.trigger 'unlocked'

    it 'should set data', ->
      expect(@data).to.deep.equal event: 'unlocked'

  describe '->on pose_off', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      @Myo.trigger 'pose_off', 'foo_off'

    it 'should set data', ->
      expect(@data).to.deep.equal event: 'foo'

  describe '->on accelerometer', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      data = x: 1
      @Myo.trigger 'accelerometer', data

    it 'should set data', ->
      data =
        x: 1
      expect(@data).to.deep.equal {event: 'accelerometer', data}

  describe '->on gyroscope', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      data = x: 1
      @Myo.trigger 'gyroscope', data

    it 'should set data', ->
      data = x: 1
      expect(@data).to.deep.equal {event: 'gyroscope', data}

  describe '->on imu', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      data = x: 1
      @Myo.trigger 'imu', data

    it 'should set data', ->
      data = x: 1
      expect(@data).to.deep.equal {event: 'imu', data}

  describe '->on rest', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      @Myo.trigger 'rest'

    it 'should set data', ->
      expect(@data).to.deep.equal event: 'rest'

  describe '->on warmup_completed', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      @Myo.trigger 'warmup_completed'

    it 'should set data', ->
      expect(@data).to.deep.equal event: 'warmup_completed'

  describe '->on emg', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      data = x: 1
      @Myo.trigger 'emg', data

    it 'should set data', ->
      data = x: 1
      expect(@data).to.deep.equal {event: 'emg', data}

  describe '->on orientation', ->
    beforeEach (done) ->
      @sut.once 'event', (@data) =>
        done()
      data = x: 1, y: 2, z: 3, w: 4
      @Myo.trigger 'orientation', data

    it 'should set data', ->
      data =
        offset:
          x: 1
          y: 2
          z: 3
          w: 4
      expect(@data).to.deep.equal {event: 'orientation', data}

  describe '->getBatteryLevel', ->
    beforeEach (done) ->
      @sut.getBatteryLevel (error, {@batteryLevel}) =>
        done error

    it 'should yield batteryLevel', ->
      expect(@batteryLevel).to.equal 2

  describe '->getBluetoothStrength', ->
    beforeEach (done) ->
      @sut.getBluetoothStrength (error, {@bluetoothStrength}) =>
        done error

    it 'should yield bluetoothStrength', ->
      expect(@bluetoothStrength).to.equal 2

  describe '->vibrate', ->
    beforeEach (done) ->
      @sut.vibrate intensity: 'yo', done

    it 'should call myo.vibrate', ->
      expect(@myo.vibrate).to.have.been.calledWith 'yo'

  describe '->unlock', ->
    beforeEach (done) ->
      @sut.unlock timed: 'yo', done

    it 'should call myo.unlock', ->
      expect(@myo.unlock).to.have.been.calledWith 'yo'

  describe '->lock', ->
    beforeEach (done) ->
      @sut.lock done

    it 'should call myo.lock', ->
      expect(@myo.lock).to.have.been.called

  describe '->zeroOrientation', ->
    beforeEach (done) ->
      @sut.zeroOrientation done

    it 'should call myo.zeroOrientation', ->
      expect(@myo.zeroOrientation).to.have.been.called
