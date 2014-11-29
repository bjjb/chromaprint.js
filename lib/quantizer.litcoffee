A very simple function that will always return 0, 1 or two for a given value,
depending on where it lies within the given constraints

    quantizer = (t0, t1, t2) ->
      (value) ->
        if value < t1
          return 0 if value < t0
          return 1
        return 2 if value < t2
        3

    module.exports = quantizer
