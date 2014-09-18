# A library for generating fingerprints of audio data, which can be used to
# identify songs.

filter = (type, y, w, h, cmp) ->
  cmp ?= filter.compare.subtractLog
  f = (img, x) -> filter[type](img, x, y, w, h, cmp)
  f.w = w
  f.h = h
  f.y = y
  f

filter[0] = (img, x, y, w, h, cmp) ->                       # oooooooooooo
  a = area(img, x, y, x + w - 1, y + h - 1)                 # oooooooooooo
  b = 0                                                     # oooooooooooo
  cmp(a, b)                                                 # oooooooooooo
                                                            # oooooooooooo
                                                            # oooooooooooo

filter[1] = (img, x, y, w, h, cmp) ->                       # ............
  h2 = h / 2                                                # ............
  a = area(img, x, y + h2, x + w - 1, y + h  - 1)           # ............
  b = area(img, x, y     , x + w - 1, y + h2 - 1)           # oooooooooooo
  cmp(a, b)                                                 # oooooooooooo
                                                            # oooooooooooo

filter[2] = (img, x, y, w, h, cmp) ->                       # ......oooooo
  w2 = w / 2                                                # ......oooooo
  a = area(img, x + w2, y,  x + w - 1,  y + h - 1)          # ......oooooo
  b = area(img, x     , y, x + w2 - 1,  y + y - 1)          # ......oooooo
  cmp(a, b)                                                 # ......oooooo
                                                            # ......oooooo

filter[3] = (img, x, y, w, h, cmp) ->                       # ......oooooo
  [w2, h2] = [w / 2, h / 2]                                 # ......oooooo
  a = area(img, x     , y + h2, x + w2 - 1, y + h  - 1) +   # ......oooooo
      area(img, x + w2, y     , x + w  - 1, y + h2 - 1)     # oooooo......
  b = area(img, x     , y     , x + w2 - 1, y + h2 - 1) +   # oooooo......
      area(img, x + w2, y + h2, x + w  - 1, y + h  - 1)     # oooooo......
  cmp(a, b)

filter[4] = (img, x, y, w, h, cmp) ->                       # ............
  h3 = h / 3                                                # ............
  a = area(img, x, y +     h3, x + w - 1, y + 2 * h3 - 1)   # oooooooooooo
  b = area(img, x, y         , x + w - 1, y +     h3 - 1) + # oooooooooooo
      area(img, x, y + 2 * h3, x + w - 1, y +     h  - 1)   # ............
  cmp(a, b)                                                 # ............
  
filter[5] = (img, x, y, w, h, cmp) ->                       # ....oooo....
  w3 = w / 3                                                # ....oooo....
  a = area(img, x +     w3, y, x + 2 * w3 - 1, y + h - 1)   # ....oooo....
  b = area(img, x         , y, x +     w3 - 1, y + h - 1) + # ....oooo....
      area(img, x + 2 * w3, y, x +     w  - 1, y + h -1)    # ....oooo....
  cmp(a, b)                                                 # ....oooo....

filter.compare =
  # Subtract one number from another
  subtract: (a, b) -> a - b
  # Subtract the log of one number from the log of another
  subtractLog: (a, b) -> Math.log(1 + a) - Math.log(1 + b)

# Gets a function that will always return 0, 1 or two for a given value,
# depending on where it lies within the given constraings
quantizer = (t0, t1, t2) ->
  (value) ->
    if value < t1
      return 0 if value < t0
      return 1
    return 2 if value < t2
    3

# Gets a function that will apply the given quantizer to the result of the
# given filter. The function also has attributes for the filter and quantizer.
classifier = (filter, quantizer) ->
  f = (image, offset) -> quantizer(filter(image, offset))
  f.filter = filter
  f.quantizer = quantizer
  f

# Gets an integral image for the given image (i.e., the summed area table)
integral = (image) ->
  result = []
  image.forEach (row, i) ->
    result[i] ?= []
    row.forEach (n, j) ->
      result[i][j] = n          +
        (result[i  ]?[j-1] ? 0) +
        (result[i-1]?[j  ] ? 0) -
        (result[i-1]?[j-1] ? 0)
  result

# Gets the area of an image, or a rectangle of an image
area = (image, x1, y1, x2, y2) ->
  x1 ?= 0
  y1 ?= 0
  x2 ?= image.length
  y2 ?= image[x2]?.length
  result = image[x2]?[y2]
  return 0 if x2 < x1 or y2 < y1
  if x1 > 0
    result -= image[x1-1][y2]
    result += image[x1-1][y1-1] if y1 > 0
  result -= image[x2][y1-1] if y1 > 0
  result

# Gives the width and height of an image
measure = (image) ->
  h: image.length
  w: image[0].length ? 0

calculator = (classifiers...) ->
  f = (w, classifier) -> Math.max(w, classifier.filter.w)
  maxFilterWidth = classifiers.reduce f, 0
  subfingerprint: (image, offset) ->
    classify = (b, classifier) -> (b << 2) | GRAYCODE[classifier(image, offset)]
    classifiers.reduce classify, 0
  fingerprint: (image) ->
    length = measure(image).h - maxFilterWidth + 1
    img = integral(image)
    @subfingerprint(img, offset) for offset in [0..length]
  maxFilterWidth: maxFilterWidth

filterCoefficients = [ 0.25, 0.75, 1, 0.75, 0.25 ]


fingerprinter = (config) ->
  config ?= test1

GRAYCODE = [ 0, 1, 3, 2 ]
SAMPLE_RATE = 11025
FRAME_SIZE = 4096
OVERLAP = FRAME_SIZE - Math.floor(FRAME_SIZE / 3)
MIN_FREQ = 28
MAX_FREQ = 3520

# Export the good stuff
@Chromaprint =
  area: area
  filter: filter
  measure: measure
  integral: integral
  quantizer: quantizer
  classifier: classifier
  calculator: calculator
  GRAYCODE: GRAYCODE

tests =
  1:
    classifiers: [
      classifier filter(0, 0, 3, 15), quantizer(2.10543, 2.45354, 2.69414)
      classifier filter(1, 0, 4, 14), quantizer(-0.345922, 0.0463746, 0.446251)
      classifier filter(1, 4, 4, 11), quantizer(-0.392132, 0.0291077, 0.443391)
      classifier filter(3, 0, 4, 14), quantizer(-0.192851, 0.00583535, 0.204053)
      classifier filter(2, 8, 2, 4), quantizer(-0.0771619, -0.00991999, 0.0575406)
      classifier filter(5, 6, 2, 15), quantizer(-0.710437, -0.518954, -0.330402)
      classifier filter(1, 9, 2, 16), quantizer(-0.353724, -0.0189719, 0.289768)
      classifier filter(3, 4, 2, 10), quantizer(-0.128418, -0.0285697, 0.0591791)
      classifier filter(3, 9, 2, 16), quantizer(-0.139052, -0.0228468, 0.0879723)
      classifier filter(2, 1, 3, 6), quantizer(-0.133562, 0.00669205, 0.155012)
      classifier filter(3, 3, 6, 2), quantizer(-0.0267, 0.00804829, 0.0459773)
      classifier filter(2, 8, 1, 10), quantizer(-0.0972417, 0.0152227, 0.129003)
      classifier filter(3, 4, 4, 14), quantizer(-0.141434, 0.00374515, 0.149935)
      classifier filter(5, 4, 2, 15), quantizer(-0.64035, -0.466999, -0.285493)
      classifier filter(5, 9, 2, 3), quantizer(-0.322792, -0.254258, -0.174278)
      classifier filter(2, 1, 8, 4), quantizer(-0.0741375, -0.00590933, 0.0600357)
    ]
    filterCoefficients: filterCoefficients
    interpolate: false
  2:
    classifiers: [
      classifier filter(0, 4, 3, 15), quantizer(1.98215, 2.35817, 2.63523)
      classifier filter(4, 4, 6, 15), quantizer(-1.03809, -0.651211, -0.282167)
      classifier filter(1, 0, 4, 16), quantizer(-0.298702, 0.119262, 0.558497)
      classifier filter(3, 8, 2, 12), quantizer(-0.105439, 0.0153946, 0.135898)
      classifier filter(3, 4, 4, 8), quantizer(-0.142891, 0.0258736, 0.200632)
      classifier filter(4, 0, 3, 5), quantizer(-0.826319, -0.590612, -0.368214)
      classifier filter(1, 2, 2, 9), quantizer(-0.557409, -0.233035, 0.0534525)
      classifier filter(2, 7, 3, 4), quantizer(-0.0646826, 0.00620476, 0.0784847)
      classifier filter(2, 6, 2, 16), quantizer(-0.192387, -0.029699, 0.215855)
      classifier filter(2, 1, 3, 2), quantizer(-0.0397818, -0.00568076, 0.0292026)
      classifier filter(5, 10, 1, 15), quantizer(-0.53823, -0.369934, -0.190235)
      classifier filter(3, 6, 2, 10), quantizer(-0.124877, 0.0296483, 0.139239)
      classifier filter(2, 1, 1, 14), quantizer(-0.101475, 0.0225617, 0.231971)
      classifier filter(3, 5, 6, 4), quantizer(-0.0799915, -0.00729616, 0.063262)
      classifier filter(1, 9, 2, 12), quantizer(-0.272556, 0.019424, 0.302559)
      classifier filter(3, 4, 2, 14), quantizer(-0.164292, -0.0321188, 0.0846339)
    ]
    filterCoefficients: filterCoefficients
    interpolate: false
  3:
    classifiers: [
      classifier filter(0, 4, 3, 15), quantizer(1.98215, 2.35817, 2.63523)
      classifier filter(4, 4, 6, 15), quantizer(-1.03809, -0.651211, -0.282167)
      classifier filter(1, 0, 4, 16), quantizer(-0.298702, 0.119262, 0.558497)
      classifier filter(3, 8, 2, 12), quantizer(-0.105439, 0.0153946, 0.135898)
      classifier filter(3, 4, 4, 8), quantizer(-0.142891, 0.0258736, 0.200632)
      classifier filter(4, 0, 3, 5), quantizer(-0.826319, -0.590612, -0.368214)
      classifier filter(1, 2, 2, 9), quantizer(-0.557409, -0.233035, 0.0534525)
      classifier filter(2, 7, 3, 4), quantizer(-0.0646826, 0.00620476, 0.0784847)
      classifier filter(2, 6, 2, 16), quantizer(-0.192387, -0.029699, 0.215855)
      classifier filter(2, 1, 3, 2), quantizer(-0.0397818, -0.00568076, 0.0292026)
      classifier filter(5, 10, 1, 15), quantizer(-0.53823, -0.369934, -0.190235)
      classifier filter(3, 6, 2, 10), quantizer(-0.124877, 0.0296483, 0.139239)
      classifier filter(2, 1, 1, 14), quantizer(-0.101475, 0.0225617, 0.231971)
      classifier filter(3, 5, 6, 4), quantizer(-0.0799915, -0.00729616, 0.063262)
      classifier filter(1, 9, 2, 12), quantizer(-0.272556, 0.019424, 0.302559)
      classifier filter(3, 4, 2, 14), quantizer(-0.164292, -0.0321188, 0.0846339)
    ]
    filterCoefficients: filterCoefficients
    interpolate: false
  4:
    removeSilence: true
    silenceThreshold: 50
