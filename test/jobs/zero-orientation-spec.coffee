{job} = require '../../jobs/zero-orientation'

describe 'ZeroOrientation', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        zeroOrientation: sinon.stub().yields null
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.zeroOrientation', ->
      expect(@connector.zeroOrientation).to.have.been.called
