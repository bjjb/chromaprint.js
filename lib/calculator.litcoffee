    GRAYCODE = [ 0, 1, 3, 2 ]
    {integral, measure} = require './images'
    filter = require('./filter')
    quantizer = require('./quantizer')
    classifier = require('./classifier')


The calculator factory expects an array of classifiers, and returns an object
with 2 functions:

    calculator = (coefficients...) ->

coefficients should be an object of coefficients to make a filter and a
quantizer, which we can then use to make a classifier.

      classifiers = coefficients.map (obj) -> classifier(obj)

We need to get the upper limit of what we can filter (the highest filter width
of any classifier).

      fn = (w, classifier) -> Math.max(w, classifier.filter.w)
      maxFilterWidth = classifiers.reduce fn, 0

This gets the fingerprint of a portion of an image

      subfingerprint: (image, offset) ->
        classify = (b, classifier) -> (b << 2) | GRAYCODE[classifier(image, offset)]
        classifiers.reduce classify, 0

This gets the fingerprint of an entire image

      fingerprint: (image) ->
        length = measure(image).h - maxFilterWidth + 1
        img = integral(image)
        @subfingerprint(img, offset) for offset in [0..length]

    module.exports = calculator
