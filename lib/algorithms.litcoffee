Algorithms for chromaprint. These are ripped shamelessly from
[AcoustID Chromaprint](https://bitbucket.org/acoustid/chromaprint/src)

    classifier  = require './classifier'
    filter      = require './filter'
    quantizer   = require './quantizer'

    filterCoefficients = [ 0.25, 0.75, 1, 0.75, 0.25 ]

    algorithms =
      1:
        classifiers: [
          classifier filter: [0, 0, 3, 15], quantizer: [2.10543, 2.45354, 2.69414]
          classifier filter: [1, 0, 4, 14], quantizer: [-0.345922, 0.0463746, 0.446251]
          classifier filter: [1, 4, 4, 11], quantizer: [-0.392132, 0.0291077, 0.443391]
          classifier filter: [3, 0, 4, 14], quantizer: [-0.192851, 0.00583535, 0.204053]
          classifier filter: [2, 8, 2, 4],  quantizer: [-0.0771619, -0.00991999, 0.0575406]
          classifier filter: [5, 6, 2, 15], quantizer: [-0.710437, -0.518954, -0.330402]
          classifier filter: [1, 9, 2, 16], quantizer: [-0.353724, -0.0189719, 0.289768]
          classifier filter: [3, 4, 2, 10], quantizer: [-0.128418, -0.0285697, 0.0591791]
          classifier filter: [3, 9, 2, 16], quantizer: [-0.139052, -0.0228468, 0.0879723]
          classifier filter: [2, 1, 3, 6],  quantizer: [-0.133562, 0.00669205, 0.155012]
          classifier filter: [3, 3, 6, 2],  quantizer: [-0.0267, 0.00804829, 0.0459773]
          classifier filter: [2, 8, 1, 10], quantizer: [-0.0972417, 0.0152227, 0.129003]
          classifier filter: [3, 4, 4, 14], quantizer: [-0.141434, 0.00374515, 0.149935]
          classifier filter: [5, 4, 2, 15], quantizer: [-0.64035, -0.466999, -0.285493]
          classifier filter: [5, 9, 2, 3],  quantizer: [-0.322792, -0.254258, -0.174278]
          classifier filter: [2, 1, 8, 4],  quantizer: [-0.0741375, -0.00590933, 0.0600357]
        ]
        filterCoefficients: filterCoefficients
        interpolate: false
      2:
        classifiers: [
          classifier filter: [0, 4, 3, 15], quantizer: [1.98215, 2.35817, 2.63523]
          classifier filter: [4, 4, 6, 15], quantizer: [-1.03809, -0.651211, -0.282167]
          classifier filter: [1, 0, 4, 16], quantizer: [-0.298702, 0.119262, 0.558497]
          classifier filter: [3, 8, 2, 12], quantizer: [-0.105439, 0.0153946, 0.135898]
          classifier filter: [3, 4, 4, 8], quantizer: [-0.142891, 0.0258736, 0.200632]
          classifier filter: [4, 0, 3, 5], quantizer: [-0.826319, -0.590612, -0.368214]
          classifier filter: [1, 2, 2, 9], quantizer: [-0.557409, -0.233035, 0.0534525]
          classifier filter: [2, 7, 3, 4], quantizer: [-0.0646826, 0.00620476, 0.0784847]
          classifier filter: [2, 6, 2, 16], quantizer: [-0.192387, -0.029699, 0.215855]
          classifier filter: [2, 1, 3, 2], quantizer: [-0.0397818, -0.00568076, 0.0292026]
          classifier filter: [5, 10, 1, 15], quantizer: [-0.53823, -0.369934, -0.190235]
          classifier filter: [3, 6, 2, 10], quantizer: [-0.124877, 0.0296483, 0.139239]
          classifier filter: [2, 1, 1, 14], quantizer: [-0.101475, 0.0225617, 0.231971]
          classifier filter: [3, 5, 6, 4], quantizer: [-0.0799915, -0.00729616, 0.063262]
          classifier filter: [1, 9, 2, 12], quantizer: [-0.272556, 0.019424, 0.302559]
          classifier filter: [3, 4, 2, 14], quantizer: [-0.164292, -0.0321188, 0.0846339]
        ]
        filterCoefficients: filterCoefficients
        interpolate: false
      3:
        classifiers: [
          classifier filter: [0, 4, 3, 15], quantizer: [1.98215, 2.35817, 2.63523]
          classifier filter: [4, 4, 6, 15], quantizer: [-1.03809, -0.651211, -0.282167]
          classifier filter: [1, 0, 4, 16], quantizer: [-0.298702, 0.119262, 0.558497]
          classifier filter: [3, 8, 2, 12], quantizer: [-0.105439, 0.0153946, 0.135898]
          classifier filter: [3, 4, 4, 8], quantizer: [-0.142891, 0.0258736, 0.200632]
          classifier filter: [4, 0, 3, 5], quantizer: [-0.826319, -0.590612, -0.368214]
          classifier filter: [1, 2, 2, 9], quantizer: [-0.557409, -0.233035, 0.0534525]
          classifier filter: [2, 7, 3, 4], quantizer: [-0.0646826, 0.00620476, 0.0784847]
          classifier filter: [2, 6, 2, 16], quantizer: [-0.192387, -0.029699, 0.215855]
          classifier filter: [2, 1, 3, 2], quantizer: [-0.0397818, -0.00568076, 0.0292026]
          classifier filter: [5, 10, 1, 15], quantizer: [-0.53823, -0.369934, -0.190235]
          classifier filter: [3, 6, 2, 10], quantizer: [-0.124877, 0.0296483, 0.139239]
          classifier filter: [2, 1, 1, 14], quantizer: [-0.101475, 0.0225617, 0.231971]
          classifier filter: [3, 5, 6, 4], quantizer: [-0.0799915, -0.00729616, 0.063262]
          classifier filter: [1, 9, 2, 12], quantizer: [-0.272556, 0.019424, 0.302559]
          classifier filter: [3, 4, 2, 14], quantizer: [-0.164292, -0.0321188, 0.0846339]
        ]
        filterCoefficients: filterCoefficients
        interpolate: false
      4:
        removeSilence: true
        silenceThreshold: 50

The default is number 2.

    algorithms.default = algorithms[2]

This structure is exported completely.

    module.exports = algorithms
