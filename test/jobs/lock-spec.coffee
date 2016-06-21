{job} = require '../../jobs/lock'

describe 'Lock', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        lock: sinon.stub().yields null
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.lock', ->
      expect(@connector.lock).to.have.been.called
