expect = require('chai').expect
cp = require('../src/chromaprint').Chromaprint

describe "images", ->
  describe "measure", ->
    img = [ [ 1, 2, 3 ], [ 3, 4, 5 ] ]
    it "tells the width and height", ->
      expect(cp.measure(img).w).to.equal 3
      expect(cp.measure(img).h).to.equal 2
  describe "integral", ->
    it "works for 2D images", ->
      img = [ [ 1, 2 ], [ 3, 4 ] ]
      expect(cp.integral(img)).to.eql [ [ 1, 3 ], [ 4, 10 ] ]
    it "works for horizontal 1D images", ->
      img = [ [ 1, 2, 3 ] ]
      expect(cp.integral(img)).to.eql [ [ 1, 3, 6 ] ]
    it "works for vertical 1D images", ->
      img = [ [ 1 ], [ 2 ], [ 3 ] ]
      expect(cp.integral(img)).to.eql [ [ 1 ], [ 3 ], [ 6 ] ]

  describe "area", ->
    img = cp.integral [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7, 8, 9 ] ]
    it "gets the right results", ->
      expect(cp.area(img, 0, 0, 0, 0)).to.equal 1
      expect(cp.area(img, 0, 0, 1, 0)).to.equal 5
      expect(cp.area(img, 0, 0, 0, 1)).to.equal 3
      expect(cp.area(img, 0, 0, 1, 1)).to.equal 12
      expect(cp.area(img, 0, 0, 2, 1)).to.equal 27
      expect(cp.area(img, 0, 1, 0, 1)).to.equal 2
      expect(cp.area(img, 0, 1, 1, 1)).to.equal 7
      expect(cp.area(img, 0, 1, 2, 1)).to.equal 15

describe "filter", ->
  cmp = cp.filter.compare.subtract
  img = cp.integral [ [ 0, 1 ], [ 2, 3 ] ]
  f = cp.filter(0, 0, 1, 1)

  it "gets a function", ->
    expect(typeof f).to.eql 'function'
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
      expect(cp.filter.compare.subtract(2, 1)).to.equal 1
    describe "subtractLog", ->
      it "subtracts the log of one number from the log of another", ->
        result = cp.filter.compare.subtractLog(2, 1).toPrecision(8)
        expect(result).to.equal '0.40546511'

describe "classifier", ->
  img = cp.integral [ [ 0, 1 ], [ 2, 3 ] ]
  filter = cp.filter(0, 0, 1, 1)
  quantizer = cp.quantizer(0.1, 1.0, 1.2)
  f = cp.classifier(filter, quantizer)
  it "is a function", ->
    expect(typeof f).to.eql 'function'
  it "has a filter attribute", ->
    expect(f.filter).to.eq filter
  it "has a quantizer attribute", ->
    expect(f.quantizer).to.eq quantizer
  it "works", ->
    expect(f(img, 0)).to.equal 0
    expect(f(img, 1)).to.equal 2

describe "calculator", ->
  filter = cp.filter(0, 0, 1, 1)
  quantizer = cp.quantizer(0.01, 1.01, 1.5)
  classifier = cp.classifier(filter, quantizer)
  calc = cp.calculator(classifier)
  it "knows its max filter width", ->
    expect(calc.maxFilterWidth).to.equal 1
  it "calculates a subfingerprint", ->
    img = cp.integral [ [ 0, 1 ], [ 2, 3 ] ]
    expect(calc.subfingerprint(img, 0)).to.equal cp.GRAYCODE[0]
    expect(calc.subfingerprint(img, 1)).to.equal cp.GRAYCODE[2]
  it "calculates a fingerprint", ->
    img = [ [ 0, 1 ], [ 2, 3 ], [ 4, 5 ] ]
    expect(calc.fingerprint(img, 0)[0]).to.equal cp.GRAYCODE[0]
    expect(calc.fingerprint(img, 1)[1]).to.equal cp.GRAYCODE[2]
    expect(calc.fingerprint(img, 2)[2]).to.equal cp.GRAYCODE[3]

describe "quantizer", ->
  f = cp.quantizer(0, 0.1, 0.3)
  it "gets a function", ->
    expect(typeof f).to.eql 'function'
  it "works", ->
    expect(f(-0.1)).to.equal 0
    expect(f(0.0)).to.equal 1
    expect(f(0.03)).to.equal 1
    expect(f(0.1)).to.equal 2
    expect(f(0.13)).to.equal 2
    expect(f(0.3)).to.equal 3
    expect(f(0.33)).to.equal 3
    expect(f(1000.0)).to.equal 3
