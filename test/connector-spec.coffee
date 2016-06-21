Connector = require '../'

describe 'Connector', ->
  beforeEach (done) ->
    @sut = new Connector
    {@myo} = @sut
    @myo.connect = sinon.stub().yields null
    @sut.start options: interval: 750, done

  afterEach (done) ->
    @sut.close done

  describe '->isOnline', ->
    it 'should yield running true', (done) ->
      @sut.isOnline (error, response) =>
        return done error if error?
        expect(response.running).to.be.true
        done()

  describe '->onConfig', ->
    beforeEach (done) ->
      options =
        interval: 750

      events =
        accelerometer: true
        gyroscope: false
        emg: true
        imu: false
        orientation: false
        pose: true

      @sut.onConfig {events, options}, done

    it 'should call myo.connect', ->
      options =
        accelerometer: true
        interval: 750
        gyroscope: false
        orientation: false
        imu: false
        emg: true
        pose: true
        
      expect(@myo.connect).to.have.been.calledWith options

  describe '->vibrate', ->
    beforeEach (done) ->
      @myo.vibrate = sinon.stub().yields null
      @sut.vibrate intensity: 'hot', done

    it 'should call myo.vibrate', ->
      expect(@myo.vibrate).to.have.been.calledWith intensity: 'hot'

  describe '->unlock', ->
    beforeEach (done) ->
      @myo.unlock = sinon.stub().yields null
      @sut.unlock timed: 'hot', done

    it 'should call myo.unlock', ->
      expect(@myo.unlock).to.have.been.calledWith timed: 'hot'

  describe '->lock', ->
    beforeEach (done) ->
      @myo.lock = sinon.stub().yields null
      @sut.lock done

    it 'should call myo.lock', ->
      expect(@myo.lock).to.have.been.called

  describe '->zeroOrientation', ->
    beforeEach (done) ->
      @myo.zeroOrientation = sinon.stub().yields null
      @sut.zeroOrientation done

    it 'should call myo.zeroOrientation', ->
      expect(@myo.zeroOrientation).to.have.been.called

  describe '->getBluetoothStrength', ->
    beforeEach (done) ->
      @myo.getBluetoothStrength = sinon.stub().yields null, bluetoothStrength: 55
      @sut.getBluetoothStrength (error, {@bluetoothStrength}) =>
        done error

    it 'should call myo.getBluetoothStrength', ->
      expect(@myo.getBluetoothStrength).to.have.been.called

    it 'should yield bluetoothStrength', ->
      expect(@bluetoothStrength).to.equal 55

  describe '->getBatteryLevel', ->
    beforeEach (done) ->
      @myo.getBatteryLevel = sinon.stub().yields null, batteryLevel: 55
      @sut.getBatteryLevel (error, {@batteryLevel}) =>
        done error

    it 'should call myo.getBatteryLevel', ->
      expect(@myo.getBatteryLevel).to.have.been.called

    it 'should yield batteryLevel', ->
      expect(@batteryLevel).to.equal 55
