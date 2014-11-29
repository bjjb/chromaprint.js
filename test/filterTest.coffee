{expect} = require 'chai'
filter = require '../lib/filter'

describe "filter", ->
  img = [ [ 0, 1 ], [ 2, 6 ] ]
  f = filter(0, 0, 1, 1)

  it "has a width addribute", ->
    expect(f.w).to.eql 1
  it "has a height addribute", ->
    expect(f.h).to.eql 1
  it "has a y attribute", ->
    expect(f.y).to.eql 0
  it "works", ->
    expect(f(img, 0)).to.equal 0
    expect(f(img, 1).toPrecision(8)).to.equal '1.0986123'

  describe "comparators", ->
    describe "subtract", ->
      it "subtracts one number from another", ->
      expect(filter.compare.subtract(2, 1)).to.equal 1
    describe "subtractLog", ->
      it "subtracts the log of one number from the log of another", ->
        result = filter.compare.subtractLog(2, 1).toPrecision(8)
        expect(result).to.equal '0.40546511'
