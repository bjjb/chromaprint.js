{expect} = require 'chai'

describe "removing silence", ->
  silenceRemover = require('../lib/silenceRemover')
  it "will allow non silence through", ->
    fn = silenceRemover(1)
    samples = [1000, 2000, 3000, 4000, 5000, 6000]
    expect(fn(samples)).to.eql samples
  it "will filter leading silence", ->
    fn = silenceRemover(100)
    samples = [0, 60, 0, 1000, 2000, 0, 4000, 5000, 0]
    expect(fn(samples)).to.eql samples[3..]
