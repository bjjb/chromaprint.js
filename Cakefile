task "test", "run all tests", ->
  npmExec "mocha"

task "build", "build JS files", ->
  npmExec "coffee -c lib/"

task "docs", "build documentation", ->
  npmExec "docco lib/*.coffee"

exec = (command) ->
  require('child_process').exec command, (err, stdout, stderr) ->
    console.log stdout if stdout
    if err
      console.error stderr or err

npmExec = (command) -> exec("node_modules/.bin/#{command}")
