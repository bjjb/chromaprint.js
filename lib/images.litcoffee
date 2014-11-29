Chromaprint works by sampling "images", which are just matrix representations
gotten by running a fast fourier transform over a portion of audio data.

Gets an integral image for the given image (i.e., the summed area table)

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

Gets the area of an image, or a rectangle of an image

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

Gives the width and height of an image

    measure = (image) ->
      h: image.length
      w: image[0].length ? 0

The images API...

    module.exports =
        integral: integral
        area: area
        measure: measure
