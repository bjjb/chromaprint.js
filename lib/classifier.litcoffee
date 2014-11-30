    filter = require './filter'
    quantizer = require './quantizer'

Classifier for chromaprint - this creates a function that applies a quantizer
the the result of a filter. The resultant function expexts an image (and an
offset into the image), and retuens the quantized and filtered result.

    classifier = (coefficients) ->

Arguments are an object containing filter coefficients and quantizer
coefficients. We make a filter and a quantizer with these.

      f = filter(coefficients.f...)
      q = quantizer(coefficients.q...)

Here's the function that gets returned with `classifier({f:[...],q[...])`.

      fn = (image, offset) -> q(f(image, offset))

The calculator will need to get the widths of the classifier's filters, so we
expose it as a property of the function.

      fn.filterWidth = f.w

Now we can return the classifier function.

      fn

The API is the factory function.

    module.exports = classifier
