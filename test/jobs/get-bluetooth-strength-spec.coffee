{job} = require '../../jobs/get-bluetooth-strength'

describe 'GetBluetoothStrength', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        getBluetoothStrength: sinon.stub().yields null, bluetoothStrength: 20
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error, {data}) =>
        {@bluetoothStrength} = data
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.getBluetoothStrength', ->
      expect(@connector.getBluetoothStrength).to.have.been.called

    it 'should yield bluetoothStrength', ->
      expect(@bluetoothStrength).to.equal 20
