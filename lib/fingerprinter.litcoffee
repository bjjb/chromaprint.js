The fingerprinter pipelines the various processors, and returns a function
that will generate a fingerprint for images.

    algorithms = require './algorithms'
    fingerprinter = (algorithm = algorithms[2]) ->
        (image) ->
