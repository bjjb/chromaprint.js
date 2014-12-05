# chromaprint.js

A JavaScript implementation of AcoustID Chromaprint. Provides a web library
for calculating chromatic fingerprints of audio data in a Javascript runtime
(such as the browser or Node), and a command-line implementation of `fpcalc`,
which gets fingerprints of local files.

## Installation and usage

### NodeJS

    npm install -g chromaprint
    fpcalc -h

or

    npm install chromaprint
    ./node_modules/.bin/fpcalc -h

### Browser

```html
    <!-- attaches a chromaprint object to window -->
    <script src="path/to/chromaprint.js"><script>
    <script>
        // Assuming loadAudio gets a decoded audio stream.
        loadAudio(url, function(stream) {
            chromaprint.calculateFingerprint(stream, console.log);
        });
    </script>
```
## API

The top-level `chromaprint` object has a number of factory functions, which it
exposes purely for testing. The public API is pretty thin, though.

* `chromaprint.calculateFingerprint(stream, [options], callback)`
  Calls `callback` with the compressed and Base64 encoded fingerprint (a
  String).
* `chromaprint.calculateRawFingerprint(stream, [options], callback)`
  Calls `callback` with the uncompressed fingerprint (a Buffer).
* `chromaprint.compress(buffer)`
  Compresses a buffer, returning a compressed Buffer.
* `chromaprint.base64encode(buffer)`
  Encodes the bytes in the buffer into a Base64 String.

## Testing and development

```
    git clone https://github.com/bjjb/chromaprint.js
    cd chromaprint.js
    npm install
    npm test
    npm test:server # starts a mocha test server
```

Report issues to the [issue tracker][issues].

## Further reading

There may be something of intrest in the [wiki][]

## License, copyright, thanks, etc

chromaprint.js is licenced under the LGPL (same as [chromaprint][]). See the
included [LICENSE][] file.

It was written by [bjjb][], as a port of [Lukáš Lalinský's][ll] original C++
library. You can read more in the README.md of the lib/] directory.

[issues]: https://github.com/bjjb/chromaprint.js/issues
[wiki]: https://github.com/bjjb/chromaprint.js/wiki
[ll]: https://oxygene.sk/
[chromaprint]: https://acoustid.org/chromaprint
[bjjb]: http://bjjb.github.io
[LICENSE]: https://raw.githubusercontent.com/bjjb/chromaprint.js/master/LICENSE
