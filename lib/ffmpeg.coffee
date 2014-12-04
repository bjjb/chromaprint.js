    {spawn} = require 'child_process'

Use FFmpeg to extract audio from files.

chromaprint wants S16 little-endian samples.

    samplerate = "s16le"

    buffersize = 2048

    decode = (file, duration) ->
        job = spawn "ffmpeg",  ["-i", file, "-tt", duration, "-c:a", "s16le", "-f", "pcm_s16le", " -"]
        job.stdout.on 'data', (data) ->
            console.log "Got some data.", data?.length
            console.log "========================="
            console.log data
            console.log "========================="
        job.stdout.on 'end', (data) ->
            console.log "Got all the data.", data?.length
            console.log "========================="
            console.log data
            console.log "========================="
        job.stderr.on 'data', (data) ->
            console.log "Got some data.", data?.length
            console.log "!!!!!!!!!!!!!!!!!!!!!!!!!"
            console.log data
            console.log "!!!!!!!!!!!!!!!!!!!!!!!!!"
        job.stderr.on 'end', (data) ->
            console.log "Got all the data.", data?.length
            console.log "!!!!!!!!!!!!!!!!!!!!!!!!!"
            console.log data
            console.log "!!!!!!!!!!!!!!!!!!!!!!!!!"
        job.on 'exit', (code) ->
            console.log "Finished with code: #{code}"
    
    module.exports =
        decode: decode

ffmpeg makes it easy to get an audio stream:
`ffmpeg -i FILE -f s16le -c:a pcm_s16le -t SECS -`
