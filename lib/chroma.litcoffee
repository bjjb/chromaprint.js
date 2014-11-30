    NUM_BANDS = 12
    log2 = Math.log(2)

Converts a frequency in Hz to its musical octave

    freqToOctave = (freq, base = 440 / 16.0) ->
      Math.log(freq / base) / log2

    chroma = (minFreq, maxFreq, frameSize, sampleRate, interpolate) ->
      notes = []
      features = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      freqToIndex = (frq) -> Math.round(frameSize * frq / sampleRate)
      indexToFreq = (idx) -> (idx * sampleRate) / frameSize
      indexToOctave = (i) -> freqToOctave(indexToFreq(i))

      minIndex = Math.max(1, freqToIndex(minFreq))
      maxIndex = Math.min(frameSize / 2, freqToIndex(maxFreq))

      for i in [minIndex...maxIndex]
        octave = indexToOctave(i)
        notes[i] = NUM_BANDS * (octave - Math.floor(octave))

Now that we have the notes filled in, we can build the function. It takes a
frame, returns the chromatic features so far.
      
      (frame) ->
        energy = (i) -> frame[i] ? 0
        for i in [minIndex...maxIndex]
          e = energy(i)
          note = notes[i]
          unit = Math.floor(note)
          fraction = note - unit
          if interpolate
            if fraction < 0.5
              unit2  = (unit + NUM_BANDS - 1) % NUM_BANDS
              a = 0.5 + fraction
            else if fraction > 0.5
              unit2 = (unit + 1) % NUM_BANDS
              a = 1.5 - fraction
            else
              unit2 = unit
              a = 1.0
            features[unit]  += e * a
            features[unit2] += e * (1 - a)
          else
            features[unit] += e
        features

    module.exports = chroma
