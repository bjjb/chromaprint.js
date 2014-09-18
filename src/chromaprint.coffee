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


GRAYCODE = [ 0, 1, 3, 2 ]

@Chromaprint =
  area: area
  filter: filter
  measure: measure
  integral: integral
  quantizer: quantizer
  classifier: classifier
  calculator: calculator
  GRAYCODE: GRAYCODE
