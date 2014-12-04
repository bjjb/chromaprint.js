task "test", "run all tests", ->
  npmRun "mocha"

task "build", "build JS files to index.js", ->
  child = npmRun "coffee -cp lib/", stdio: [process.stdin, 'pipe', process.stderr]
  output = require('fs').createWriteStream('index.js', 'w', encoding: 'utf8')
  child.stdout.pipe(output)

task "docs", "build documentation", ->
  npmRun "docco lib/*.coffee"

task "clean", "remove documentation and index.js", ->
  run "rm -rf docs index.js"

run = (cmd, options = {}) ->
  options.stdio ?= 'inherit'
  [cmd, args...] = cmd.split(' ').filter((x) -> !!x)
  require('child_process').spawn cmd, args, options

npmRun = (command, options) -> run("node_modules/.bin/#{command}", options)
