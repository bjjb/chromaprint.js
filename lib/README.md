# chromaprint.js library

## Introduction

Chromaprint is an [accoustic fingerprinter][1] calculator. That is, it process
a stream of data which represents a piece of digital audio, and produces kind
of number that will be the same for all _similar_ pieces of audio. Hence, a
noisy copy of a song should have the same fingerprint as a higher quality copy
of the song, since the "notes" in the song should be more or less the same,
and hence the "chroma" should be pretty much identical.  This kind of
fingerprinting was developed to help identify faces and objects in digital
images, but it applies equally well to audio characteristics.

The upshot is that "songs" can now be identified using their audio
characteristics, rather than arbitrarily inserted metadata or filenames or
whatever. SoundHound and Google Play Sound Search (probably) work in this way.

## AcoustID Chromaprint

[Lukáš Lalinský][2] wrote a wonderful [C++ library called Chromaprint][3], and
used that as the basis for a [database][4] of audio fingerprints, called
AcoustID.  [Musicbrainz][5] now use this repository of fingerprints in their
extensive catalog of music meta-data. AcoustID Chromaprint ships with an
example app called `fpcalc` that generates fingerprints for files on the
command-line.

The C++ implementation of `fpcalc` works as follows:

    AudioProcessor → SilenceRemover → FFT → Chroma → FingerprintCalculator

### AudioProcessor

The `AudioProcessor` takes a stream of raw audio bytes, resamples them (using
an external library, such as libav), and passes them into either a
SilenceRemover or a fast Fourier transform.

### SilenceRemover

The `SilenceRemover` is optional. If present, it removes only leading silence
(energies below a certain threshold) from the input, and passes the remainder
into the FFT.

### FFT

[FFTs][9] are commonplace in signal processing - a [DFT][10] represents a list
of samples' frequencies in a conveniently ordered way.

The FFT module takes the (resampled, possible silence-stripped) input and does
a fast Fourier transform on it using an external library (such as libav or
fftw). Its window is a Hamming window. The output is fed to the Chroma module.

### Chroma

Here's the interesting part. The Chroma module is split into three parts, a
feature detector, a filter, and a normalizer.

    FeatureDetector → Filter → Normalizer → ImageBuilder

#### FeatureDetector

The feature detector (simply called "Chroma") picks out "notes" from the
input. This provides a list of numbers which neatly identify the "sound" in a
sample. The result is a list of real numbers, which will be used to build up
the "image".

#### Filter

The Chroma Filter applies some transformation to the input, essentially
multiplying numbers in its input by pre-configured coefficients. The filter
coefficients are chosen from a list of available "algorithms".

### Normalizer

The Normalizer applies a Euclidian norm to the input, and feeds the result to
an ImageBuilder

### ImageBuilder

The ImageBuilder simply takes its input and outputs an "image", where each row
is the list of features that were passed in.

### FingerprintCalculator

The calculator takes the image, calculates the summed area table, and then
gets a corresponding greyscale value for each point. 

Once the result is compressed and Base64 encoded, you have an audio fingerprint!

## Implementation in JS

I wanted to be able to do this in the browser - primarily to harnass the
new(ish) [Media Capture API][6] and [Web Audio API][7] to pull metadata in
about a playing song, and also to potentially use in the web clients of my
[mmmgr][8] suite (if it ever gets finished).

Fortunately, Lukáš's library is well tested, and written in nice, clean C++,
so porting it was... well, not trivial, but certainly not *difficult* (in the
engineering sense). He even provides references to the work upon which his own
is based.

JavaScript allows for far more concise code (and CoffeeScript even more so),
so the two libraries appear quite different, but they fundamentally do the
same thing.

The (modern) browser environment already provides audio decoding, so the
resampling needs to be done with the Web Audio API. However, on the
command-line, we could continue to use libav, or (perhaps naïvely) just run
`ffmpeg` if it's available. Anyway, this implementation needs to choose its
underlying audio decoder intelligently.

The FFT library was implemented in [DSP.js][11], saving some effort. A lot of
the C++ code is buffer handling, which is abstracted away by Stream APIs in
both the browser and NodeJS.

[1]: http://en.wikipedia.org/wiki/Acoustic_fingerprint
[2]: https://oxygene.sk/
[3]: https://bitbucket.org/acoustid/chromaprint
[4]: http://acoustid.org/
[5]: https://musicbrainz.org/
[6]: http://www.w3.org/TR/mediacapture-streams/
[7]: http://www.w3.org/TR/webaudio/
[8]: https://github.com/bjjb/mmmgr
[9]: http://en.wikipedia.org/wiki/Fast_Fourier_transform
[10]: http://en.wikipedia.org/wiki/Discrete_Fourier_transform
[11]: https://github.com/corbanbrook/dsp.js/
