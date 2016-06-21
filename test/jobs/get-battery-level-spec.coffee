{job} = require '../../jobs/get-battery-level'

describe 'GetBatteryLevel', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        getBatteryLevel: sinon.stub().yields null, batteryLevel: 20
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error, {data}) =>
        {@batteryLevel} = data
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.getBatteryLevel', ->
      expect(@connector.getBatteryLevel).to.have.been.called

    it 'should yield batteryLevel', ->
      expect(@batteryLevel).to.equal 20
