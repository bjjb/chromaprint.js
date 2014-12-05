{ expect } = @chai or require('chai')
{ chroma } = @chromaprint or require('../lib/chroma').chromaprint

describe "calculating chroma features", ->
  it "properly calculates A", ->
    fn = chroma(10, 510, 256, 1000)
    expect(fn(113: 1)).to.eql [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  it "properly calculates G♯", ->
    fn = chroma(10, 510, 256, 1000)
    expect(fn(112: 1)).to.eql [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
  it "properly calculates B", ->
    fn = chroma(10, 510, 256, 1000)
    expect(fn(64: 1)).to.eql [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  it "properly calculates an interpolated B", ->
    fn = chroma(10, 510, 256, 1000, true)
    results = fn(64: 1)
    expect(results[0]).to.eq 0
    expect(Number(results[1].toPrecision(6))).to.eq 0.286905
    expect(Number(results[2].toPrecision(6))).to.eq 0.713095
    expect(results[3..]).to.eql [0, 0, 0, 0, 0, 0, 0, 0, 0]
  it "properly calculates an interpolated A", ->
    fn = chroma(10, 510, 256, 1000, true)
    results = fn(113: 1)
    expect(Number(results[0].toPrecision(6))).to.eq 0.555242
    expect(results[1..-2]).to.eql [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    expect(Number(results[11].toPrecision(6))).to.eq 0.444758
  it "properly calculates an interpolated G♯", ->
    fn = chroma(10, 510, 256, 1000, true)
    results = fn(112: 1)
    expect(results[1..-2]).to.eql [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    expect(Number(results[11].toPrecision(6))).to.eq 0.598646

