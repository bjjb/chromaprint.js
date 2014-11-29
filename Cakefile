task "test", "run all tests", ->
  npmExec "mocha"

task "build", "build JS files", ->
  npmExec "coffee -c lib/"

task "docs", "build documentation", ->
  npmExec "docco lib/*.*.md"

if process.platform is 'darwin'
  task "sample.aiff", "generate /test.sample.aiff, a sample audio file", ->
    exec "say -v Moira -f #{__dirname}/README.md -o test/sample"
else # flite needs to be in the PATH.
  task "sample.wav", "generate /test/sample.wav, a sample audio file", ->
    exec "flite -voice slt -f #{__dirname}/README.md -o test.sample.wav"

exec = (command) ->
  require('child_process').exec command, (err, stdout, stderr) ->
    console.log stdout if stdout
    if err
      console.error stderr or err

npmExec = (command) -> exec("node_modules/.bin/#{command}")
