return unless require? and module? # protect the browser

fs = require('fs')
cli = require('commander')
path = require('path')
Promise = require('q')

cli.description "Print the audio fingerprint of one or more files."

cli.usage '[options] <file ...>'

cli.version require('../package').version

cli.option '-l, --length SECS',
           'seconds of audio to scan [120]',
           parseInt,
           120

cli.option '-r, --raw', 'output the raw uncompressed fingerprint'

cli.option '-a, --algo TEST',
           'choose an algorithm (1-4) [2]',
           parseInt,
           2

print = (file, length, fingerprint) ->
  console.log "FILE=#{file}"
  console.log "DURATION=#{length}"
  console.log "FINGERPRINT=#{fingerprint}"
  console.log ""

fpcalc = (file, length, raw, algorithm, callback) ->
  offset = 0
  position = null
  l = 2048
  audioBuffer = new Buffer(l)
  readCallback = (err, bytesRead, buffer) ->
    return callback(err) if err?
    console.log "Read #{bytesRead} bytes => #{buffer}"
    console.log "  audioBuffer is now: #{buffer}"
    console.log "  ... I think I will stop now."
    callback(null, audioBuffer)
  read = (err, fd) ->
    return callback(err) if err?
    fs.read(fd, audioBuffer, offset, l, position, callback)
  fs.exists path.resolve(file), (ok) ->
    return fs.open(file, 'r', read) if ok
    callback Error("#{file} - no such file ")


run = (args = process.argv) ->
  cli.parse(args)
  raw = !!cli.raw
  length = cli.length or 120
  algorithm = cli.algorithm or 2
  cli.help() unless cli.args.length # exits immediately
  f = (file, cb) -> fpcalc(file, length, raw, algorithm, cb)
  cli.args.reverse().reduce(((p, n) -> (-> f(n, p))), ->)()

module?.exports = run
