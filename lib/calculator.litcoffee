    GRAYCODE = [ 0, 1, 3, 2 ]
    {integral, measure} = require './images'
    classifier = require './classifier'


The calculator factory expects an array of classifiers, and returns an object
with 2 functions:

    calculator = (coefficients...) ->

coefficients should be an array of coefficient objects, each of which are the
arguments to classifier, so we can just define all the classifiers as:

      classifiers = coefficients.map classifier

We need to get the upper limit of what we can filter (the highest filter width
of any classifier).

      max = classifiers.reduce ((w, c) -> Math.max(w, c.filterWidth)), 0

This gets the fingerprint of a portion of an image, and its used by the
fingerprint calculator function below.

      subfingerprint = (image, offset) ->
        classify = (b, classifier) -> (b << 2) | GRAYCODE[classifier(image, offset)]
        classifiers.reduce classify, 0

This is the returned function, which takes an image, and calculates the
subfingerprints of its integral in chunks (depending on how wide the filters
are).

      (image) ->
        length = measure(image).h - max + 1
        img = integral(image)
        subfingerprint(img, offset) for offset in [0...length]

We expose the factory.

    module.exports = calculator
