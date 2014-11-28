chromaprint = require('./src/chromaprint')

fpcalc = require('commander')
  .version('0.0.1')
  .usage('[options] <file>')
  .option('-l, --length SECONDS', 'length of audio data to scan [120]')
  .option('-r, --raw', 'output the raw uncompressed fingerprint')
  .option('-a, --algo TEST', 'choose the encoding algorithm [2]')
  .parse(process.argv)
  
console.log("OK")
