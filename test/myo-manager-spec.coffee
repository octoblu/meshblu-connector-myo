MyoManager = require '../src/myo-manager'

describe 'MyoManager', ->
  beforeEach ->
    @sut = new MyoManager

  it 'should exist', ->
    expect(@sut).to.exist
