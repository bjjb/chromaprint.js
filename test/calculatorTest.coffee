expect = require('chai').expect

describe "a calculator with known filter and quantizer co-efficients", ->
  calculator = require('../lib/calculator')
    filter: [0, 0, 1, 1]
    quantizer: [0.01, 1.01, 1.5]
  it "calculates the right subfingerprint for offsets", ->
    #img = integral [ [ 0, 1 ], [ 2, 3 ] ]
    img = [ [ 0, 1 ], [ 2, 6 ] ]
    expect(calculator.subfingerprint(img, 0)).to.equal 0
    expect(calculator.subfingerprint(img, 1)).to.equal 3
  it "calculates the right fingerprint", ->
    img = [ [ 0, 1 ], [ 2, 3 ], [ 4, 5 ] ]
    expect(calculator.fingerprint(img, 0)[0]).to.equal 0
    expect(calculator.fingerprint(img, 1)[1]).to.equal 3
    expect(calculator.fingerprint(img, 2)[2]).to.equal 2
