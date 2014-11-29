{expect} = require 'chai'
algorithms = require '../lib/algorithms'

describe 'algorithms', ->
  it "has 4", ->
    for n in [1..4]
      expect(algorithms[n]).to.be.an 'object'
  it "has a default", ->
    expect(algorithms[2]).to.eq algorithms.default
