task "test", "run all tests", ->
  invoke "build"
  run "mocha"

task "build", "build JS files", ->
  run "coffee -c lib/"

{ exec } = require('child_process')
run = (command) ->
  exec "node_modules/.bin/#{command}", (err, stdout, stderr) ->
    console.log stdout if stdout
    console.error stderr if stderr
    throw err if err
