Gets a function for removing silence from a buffer. It can be configured with
a silence threshold. The window is also configurable (see the filter function
below), but defaults to 55, which, I am told, is 5ms at 11025 Hz.

    silenceRemover = (threshold, window = 55) ->

The filter returns a function that returns true if the average ever passes
above the threshold. The window is the starting point when summing up the
bytes for the average.

      filter = (window) ->
        finished = false
        (byte, index) ->
          finished or= ((window += byte) / (index + 1)) > threshold

This function returns what it's given only if the average has s
The returned function takes an array of bytes, only returns those that occur
after the average has surpassed the silence threshold.

      (input) -> input.filter filter(window)

    module.exports = silenceRemover
