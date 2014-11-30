expect = require('chai').expect

describe "a calculator with known filter and quantizer co-efficients", ->
  calculate = require('../lib/calculator')
    f: [0, 0, 1, 1]
    q: [0.01, 1.01, 1.5]
  it "calculates the right fingerprint", ->
    img = [ [ 0, 1 ], [ 2, 3 ], [ 4, 5 ] ]
    expect(calculate(img)).to.eql [0, 3, 2]
