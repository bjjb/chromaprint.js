expect = require('chai').expect
cp = require('../lib/chromaprint').Chromaprint

describe "images", ->
  describe "measure", ->
    {measure} = cp
    img = [ [ 1, 2, 3 ], [ 3, 4, 5 ] ]
    it "tells the width and height", ->
      expect(measure(img).w).to.equal 3
      expect(measure(img).h).to.equal 2
  describe "integral", ->
    {integral} = cp
    it "works for 2D images", ->
      img = [ [ 1, 2 ], [ 3, 4 ] ]
      expect(integral(img)).to.eql [ [ 1, 3 ], [ 4, 10 ] ]
    it "works for horizontal 1D images", ->
      img = [ [ 1, 2, 3 ] ]
      expect(integral(img)).to.eql [ [ 1, 3, 6 ] ]
    it "works for vertical 1D images", ->
      img = [ [ 1 ], [ 2 ], [ 3 ] ]
      expect(integral(img)).to.eql [ [ 1 ], [ 3 ], [ 6 ] ]

  describe "area", ->
    {integral, area} = cp
    img = integral [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7, 8, 9 ] ]
    it "gets the right results", ->
      expect(area(img, 0, 0, 0, 0)).to.equal 1
      expect(area(img, 0, 0, 1, 0)).to.equal 5
      expect(area(img, 0, 0, 0, 1)).to.equal 3
      expect(area(img, 0, 0, 1, 1)).to.equal 12
      expect(area(img, 0, 0, 2, 1)).to.equal 27
      expect(area(img, 0, 1, 0, 1)).to.equal 2
      expect(area(img, 0, 1, 1, 1)).to.equal 7
      expect(area(img, 0, 1, 2, 1)).to.equal 15

describe "filter", ->
  {filter, integral} = cp
  cmp = filter.compare.subtract
  img = integral [ [ 0, 1 ], [ 2, 3 ] ]
  f = filter(0, 0, 1, 1)

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
      expect(filter.compare.subtract(2, 1)).to.equal 1
    describe "subtractLog", ->
      it "subtracts the log of one number from the log of another", ->
        result = filter.compare.subtractLog(2, 1).toPrecision(8)
        expect(result).to.equal '0.40546511'

describe "classifier", ->
  {integral, filter, quantizer, classifier} = cp
  img = integral [ [ 0, 1 ], [ 2, 3 ] ]
  filter = filter(0, 0, 1, 1)
  quantizer = quantizer(0.1, 1.0, 1.2)
  f = classifier(filter, quantizer)
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
  {integral, filter, quantizer, classifier, calculator, graycode} = cp
  filter = filter(0, 0, 1, 1)
  quantizer = quantizer(0.01, 1.01, 1.5)
  classifier = classifier(filter, quantizer)
  calc = calculator(classifier)
  it "knows its max filter width", ->
    expect(calc.maxFilterWidth).to.equal 1
  it "calculates a subfingerprint", ->
    img = integral [ [ 0, 1 ], [ 2, 3 ] ]
    expect(calc.subfingerprint(img, 0)).to.equal graycode[0]
    expect(calc.subfingerprint(img, 1)).to.equal graycode[2]
  it "calculates a fingerprint", ->
    img = [ [ 0, 1 ], [ 2, 3 ], [ 4, 5 ] ]
    expect(calc.fingerprint(img, 0)[0]).to.equal graycode[0]
    expect(calc.fingerprint(img, 1)[1]).to.equal graycode[2]
    expect(calc.fingerprint(img, 2)[2]).to.equal graycode[3]

describe "quantizer", ->
  {quantizer} = cp
  f = quantizer(0, 0.1, 0.3)
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

describe "fingerprinter", ->
  {fingerprinter} = cp
  it "gets a function", ->
    f = fingerprinter()
    expect(f).to.be.a 'function'
