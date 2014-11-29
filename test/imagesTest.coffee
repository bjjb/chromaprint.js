{expect} = require('chai')
{area, integral, measure} = require '../lib/images'

describe "measure", ->
  img = [ [ 1, 2, 3 ], [ 3, 4, 5 ] ]
  it "tells the width and height", ->
    expect(measure(img).w).to.equal 3
    expect(measure(img).h).to.equal 2
describe "integral", ->
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
