{job} = require '../../jobs/unlock'

describe 'Unlock', ->
  context 'when given a valid message', ->
    beforeEach (done) ->
      @connector =
        unlock: sinon.stub().yields null
      message =
        data:
          timed: 'hi'
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should not error', ->
      expect(@error).not.to.exist

    it 'should call connector.unlock', ->
      expect(@connector.unlock).to.have.been.calledWith timed: 'hi'

  context 'when given an invalid message', ->
    beforeEach (done) ->
      @connector = {}
      message = {}
      @sut = new job {@connector}
      @sut.do message, (@error) =>
        done()

    it 'should error', ->
      expect(@error).to.exist
