{expect} = require 'chai'

describe "quantizer", ->
  q = require('../lib/quantizer')(0, 0.1, 0.3)
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
