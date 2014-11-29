A filter in chromaprint modifies a portion of an image. There are 5
different filters available. The `filter` function takes as arguments:

1. the type of filter (0-4)
2. the y offset from where to apply the comparison
3. the x offset from where to apply the comparison
4. the width upon which to run the comparison
5. the height upon which to run the comparison
6. the actual comparison function (currently always subtraction, but log
   subtraction is also available.


    {area} = require './images'

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


These are the function that are used for each number in the images being
filtered. They do basically as they say.

    filter.compare =
      subtract: (a, b) -> a - b
      subtractLog: (a, b) -> Math.log(1 + a) - Math.log(1 + b)

The API is the function.

    module.exports = filter
