    filter = require './filter'
    quantizer = require './quantizer'

Classifier for chromaprint - this creates a function that applies a quantizer
the the result of a filter. The resultant function expexts an image (and an
offset into the image), and retuens the quantized and filtered result.

    classifier = (coefficients) ->

Arguments are an object containing filter coefficients and quantizer
coefficients. We make a filter and a quantizer with these.

      f = filter(coefficients.filter...)
      q = quantizer(coefficients.quantizer...)
      fn = (image, offset) -> q(f(image, offset))

The filter and the quantizer need to be exposed (so we know how wide a filter
is, for example)

      fn.quantizer = q
      fn.filter = f
      fn

The API is the factory function.

    module.exports = classifier
