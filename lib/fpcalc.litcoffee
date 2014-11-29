This is a proof-of-concept port of the canonical fpcalc example utility that
ships with AcoustID Chromaprint.

    chromaprint = require './fingerprinter'

This being a command-line application, we don't have the browser's audio
processing capabilities, so we use whatever the OS has available. Currently,
only ffmpeg is supported.

    audioDecoder = require './ffmpeg'

The program is based on [commander](https://www.npmjs.org/package/commander).

    cli = require 'commander'
    cli.description "Print the audio fingerprint of one or more files."

It can handle one or more files. If no file is given, it will use standard
input.

    cli.usage '[options] <file ...>'

The version number is in the package JSON.

    cli.version require('../package').version

    cli.option '-l, --length SECS',
               'seconds of audio to scan [120]',
               parseInt,
               120

    cli.option '-r, --raw', 'output the raw uncompressed fingerprint'

The `algo` option chooses an algorithm for chromaprint to use - see
[algorithms](algorithms.html) for details. The default is number 2.

    cli.option '-a, --algo TEST',
               'choose an algorithm (1-4) [2]',
               parseInt,
               2

    print = (file, length, fingerprint) ->
      console.log "FILE=#{file}"
      console.log "DURATION=#{length}"
      console.log "FINGERPRINT=#{fingerprint}"
      console.log ""

This is where all the work is done. First, we create a chromaprint calculator
with the given algorithm. Then we open the file stream, and decode length
seconds of audio into a buffer. This buffer is fed into the calculator. The
frames from the calculator are encoded, (unless raw is true) and when it's
finished, the print function is called.

    fpcalc = (file, length, raw, algorithm, callback) ->
      x for x in [0..1e9]
      print(file, length, "bcjkdsncjksc")
      callback()

Since this is basically a command-line application, we can just call it with
the `run` function. Usually we'll simply use the process's `argv` to extract
the options, but they can be passed, in case we want to use `run` for
something else (in tests, for example). The function is _not_ async - its
behaviour is to simply output fingerprints (as it gets them) to standard
output.

    run = (args = process.argv) ->
      cli.parse(args)
      raw = !!cli.raw
      length = cli.length or 120
      algorithm = cli.algorithm or 2
      cli.help() unless cli.args.length # exits immediately
      # Reduce over the files to process them sequentially
      f = (file, cb) -> fpcalc(file, length, raw, algorithm, cb)
      cli.args.reverse().reduce(((p, n) -> (-> f(n, p))), ->)()


API is just the run function.

    module.exports = run

*TEST*

    run(process.argv)
