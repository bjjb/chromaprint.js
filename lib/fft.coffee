
    fft = (frameSize, overlap) ->
      frameSize ?= Math.abs(4096)
      overlap   ?= Math.abs(frameSize - frameSize / 3)
      increment  = frameSize - overlap
      window     = new Uint8Array(frameSize)
      window[n]  = 0xff for n in [0..frameSize]
      buffer = new Array(frameSize)

    fft.window =
      hamming: (n) ->
        [0...n].map (i) ->
          0.54 - (0.46 * Math.cos((2 * Math.PI * i) / (n - 1)))

    module.exports = fft
