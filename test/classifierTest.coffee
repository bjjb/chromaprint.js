{expect} = require 'chai'
classifier = require '../lib/classifier'

describe "classifier", ->
  img = [ [ 0, 1 ], [ 2, 6 ] ]
  f = classifier
    filter: [0, 0, 1, 1]
    quantizer: [0.1, 1.0, 1.2]
  it "works", ->
    expect(f(img, 0)).to.equal 0
    expect(f(img, 1)).to.equal 2
