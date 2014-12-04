{expect} = require 'chai'
fft = require '../lib/fft'

describe "FFT calculation", ->

  it "has a working hamming window", ->
    hamming = fft.window.hamming
    expected = [
      0.08, 0.187619556165, 0.460121838273, 0.77, 0.972258605562,
      0.972258605562, 0.77, 0.460121838273, 0.187619556165, 0.08
    ].map(precision12)
    actual = hamming(10).map(precision12)
    expect(actual).to.eql expected

precision12 = (n) -> Number(n.toPrecision(12))
