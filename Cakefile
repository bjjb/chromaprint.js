task "test", "run all tests", ->
  invoke "build"
  run "node_modules/.bin/mocha --compilers coffee:coffee-script/register"

task "build", "build JS files", ->
  run "node_modules/.bin/coffee -o lib src/"

{ exec } = require('child_process')
run = (command) ->
  exec command, (err, stdout, stderr) ->
    console.log stdout if stdout
    console.error stderr if stderr
    throw err if err
