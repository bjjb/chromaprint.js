@chromaprint ?= {}

# Creating images comes down to choosing a 'shade of grey' from here.

GRAYCODE = [ 0, 1, 3, 2 ]
@chromaprint.GRAYCODE = GRAYCODE

# Images
# ======
#
# Chromaprint does its work on "images" - 2 dimensional arrays which are
# calculated from an input stream.
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

measure = (image) ->
  h: image.length
  w: image[0].length ? 0

@chromaprint.Image = { integral, area, measure }

# Filters
# =======
#
# A filter in chromaprint modifies a portion of an image. There are 5
# different filters available. The `filter` function takes as arguments:
# 1. the type of filter (0-4)
# 2. the y offset from where to apply the comparison
# 3. the x offset from where to apply the comparison
# 4. the width upon which to run the comparison
# 5. the height upon which to run the comparison
# 6. the actual comparison function (currently always subtraction, but log
#    subtraction is also available.
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
  subtract: (a, b) -> a - b
  subtractLog: (a, b) -> Math.log(1 + a) - Math.log(1 + b)

@chromaprint.filter = filter

# Quantizer
# =========
#
# Makes a very simple function to return 0, 1, 2, or 3 depending on where the
# value falls within the three values given.
quantizer = (t0, t1, t2) ->
  (value) ->
    if value < t1
      return 0 if value < t0
      return 1
    return 2 if value < t2
    3
@chromaprint.quantizer = quantizer

# Classifiers
# ===========
# 
# classifier is a higher order function that makes a filter and a quantizer
# work together on an image.
classifier = (coefficients) ->
  f = filter(coefficients.f...)
  q = quantizer(coefficients.q...)
  fn = (image, offset) -> q(f(image, offset))
  fn.filterWidth = f.w
  fn
@chromaprint.classifier = classifier

# Calculator
# ==========
#
# The calculator actually calculates the fingerprint of an image, by creating
# the right classifier, and passing the image into the resulting function in
# chunks.
calculator = (coefficients...) ->
  classifiers = coefficients.map (cc) ->
    classifier(cc)

  max = classifiers.reduce ((w, c) -> Math.max(w, c.filterWidth)), 0

  subfingerprint = (image, offset) ->
    classify = (b, classifier) -> (b << 2) | GRAYCODE[classifier(image, offset)]
    classifiers.reduce classify, 0
  (image) ->
    length = measure(image).h - max + 1
    img = integral(image)
    subfingerprint(img, offset) for offset in [0...length]

@chromaprint.calculator = calculator
