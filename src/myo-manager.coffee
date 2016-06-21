Myo = require 'myo'

class MyoManager
  constructor: ->
    # hook for tests
    @myo = Myo

  connect: (options, callback) =>

module.exports = MyoManager
