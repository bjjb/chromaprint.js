{ expect } = @chai ? require('chai')
chromaprint = @chromaprint ? require('../lib/calculator').chromaprint

describe "images", ->
  { Image: { measure, area, integral } } = chromaprint
  describe "measure", ->
    img = [ [ 1, 2, 3 ], [ 3, 4, 5 ] ]
    it "is a function", ->
      expect(measure).to.be.a 'function'
    it "tells the width and height", ->
      expect(measure(img).w).to.equal 3
      expect(measure(img).h).to.equal 2
  describe "integral", ->
    it "is a function", ->
      expect(integral).to.be.a 'function'
    it "works for 2D images", ->
      img = [ [ 1, 2 ], [ 3, 4 ] ]
      expect(integral(img)).to.eql [ [ 1, 3 ], [ 4, 10 ] ]
    it "works for horizontal 1D images", ->
      img = [ [ 1, 2, 3 ] ]
      expect(integral(img)).to.eql [ [ 1, 3, 6 ] ]
    it "works for vertical 1D images", ->
      img = [ [ 1 ], [ 2 ], [ 3 ] ]
      expect(integral(img)).to.eql [ [ 1 ], [ 3 ], [ 6 ] ]

  describe "area of integrals", ->
    it "is a function", ->
      expect(area).to.be.a 'function'
    it "correctly calculates areas", ->
      # img = integral [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7, 8, 9 ] ]
      img = [ [ 1, 3, 6 ], [ 5, 12, 21 ], [ 12, 27, 45 ] ]
      expect(area(img, 0, 0, 0, 0)).to.equal 1
      expect(area(img, 0, 0, 1, 0)).to.equal 5
      expect(area(img, 0, 0, 0, 1)).to.equal 3
      expect(area(img, 0, 0, 1, 1)).to.equal 12
      expect(area(img, 0, 0, 2, 1)).to.equal 27
      expect(area(img, 0, 1, 0, 1)).to.equal 2
      expect(area(img, 0, 1, 1, 1)).to.equal 7
      expect(area(img, 0, 1, 2, 1)).to.equal 15

describe "filter", ->
  { filter } = chromaprint
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

describe "quantizer", ->
  { quantizer } = chromaprint
  q = quantizer(0, 0.1, 0.3)
  it "quantizes negative numbers", ->
    expect(q(-0.1)).to.equal 0
  it "quantizes zero", ->
    expect(q(0.0)).to.equal 1
  it "quantizes small numbers", ->
    expect(q(0.03)).to.equal 1
  it "quantizes edge cases", ->
    expect(q(0.1)).to.equal 2
  it "quantizes witin bounds", ->
    expect(q(0.13)).to.equal 2
  it "quantizes upper cases", ->
    expect(q(0.3)).to.equal 3
  it "quantizes upper numbers", ->
    expect(q(0.33)).to.equal 3
  it "quantizes huge numbers", ->
    expect(q(1000.0)).to.equal 3

describe "a classifier", ->
  { classifier } = chromaprint
  img = [ [ 0, 1 ], [ 2, 6 ] ]
  f = classifier
    f: [0, 0, 1, 1]
    q: [0.1, 1.0, 1.2]
  it "works", ->
    expect(f(img, 0)).to.equal 0
    expect(f(img, 1)).to.equal 2

describe "a calculator with known filter and quantizer co-efficients", ->
  { calculator } = chromaprint
  calculate = calculator(f: [0, 0, 1, 1], q: [0.01, 1.01, 1.5])
  it "calculates the right fingerprint for an image", ->
    img = [ [ 0, 1 ], [ 2, 3 ], [ 4, 5 ] ]
    expect(calculate(img)).to.eql [0, 3, 2]
