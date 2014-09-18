# Calculate a summed area table for the given table i
@integralImage = @sat = (i) ->
  ii = []
  i.forEach (j, x) ->
    ii[x] ?= []
    j.forEach (n, y) ->
      ii[x][y] = n + (ii[x][y - 1] ? 0) + (ii[x-1]?[y] ? 0) - (ii[x-1]?[y-1] ? 0)
  ii
