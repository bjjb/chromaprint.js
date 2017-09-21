task "test", "run all tests", ->
  npmRun "mocha test/*.coffee"

task "test:server", "start a test server", ->
  invoke "build"
  invoke "build:tests"
  startTestServer()

task "test:headless", "run browser tests with phantomJS", ->
  invoke "build"
  invoke "build:tests"
  startTestServer (server) ->
    tests = npmRun 'mocha-phantomjs -R dot http://localhost:8088/test/'
    tests.on 'exit', () -> server.kill('SIGHUP')

task "build:tests", "compile test/index.js, the browser test suite", ->
  child = npmRun "coffee -cp test/", stdio: [process.stdin, 'pipe', process.stderr]
  output = require('fs').createWriteStream('test/index.js', encoding: 'utf8')
  child.stdout.pipe(output)

task "build", "build JS files to index.js", ->
  child = npmRun "coffee -cp lib/", stdio: [process.stdin, 'pipe', process.stderr]
  output = require('fs').createWriteStream('index.js', encoding: 'utf8')
  child.stdout.pipe(output)

task "docs", "build documentation", ->
  npmRun "docco lib/*.coffee"

task "clean", "remove documentation and index.js", ->
  run "rm -rf docs index.js test/index.js"

run = (cmd, options = {}) ->
  options.stdio ?= 'inherit'
  [cmd, args...] = cmd.split(' ').filter((x) -> !!x)
  require('child_process').spawn cmd, args, options

startTestServer = (callback) ->
  port = process.env.PORT or 8088
  callback ?= -> console.log "Open http://localhost:#{port}/test to run the tests."
  callback npmRun "http-server -s -c-1 -p #{port} ."

npmRun = (command, options) -> run("node_modules/.bin/#{command}", options)
