{ expect } = @chai or require('chai')
{ ALGORITHMS } = @chromaprint or require('../lib/algorithms').chromaprint

describe "algorithms", ->
  it "is an object", ->
    expect(ALGORITHMS).to.be.an 'object'
  it "has 4 distinct algorithms", ->
    for n in [1..4]
      expect(ALGORITHMS[n]).to.be.an 'object'
      expect(ALGORITHMS["#{n}"]).to.eq ALGORITHMS[n]
  it "has a default", ->
    expect(ALGORITHMS.default).to.eq ALGORITHMS[2]

describe "an algorithm", ->
  algorithm = ALGORITHMS.default
  it "has classifierCoefficients", ->
    expect(algorithm.classifierCoefficients).to.be.an 'array'
    expect(algorithm.classifierCoefficients.length).to.eq 16
    algorithm.classifierCoefficients.forEach (cc) ->
      expect(cc).to.be.an 'object'
      expect(cc.f).to.be.an 'array'
      expect(cc.f.length).to.eq 4
      expect(cc.q).to.be.an 'array'
      expect(cc.q.length).to.eq 3
