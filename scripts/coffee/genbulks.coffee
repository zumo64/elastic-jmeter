fs = require 'fs'
mkdirp = require 'mkdirp'
rimraf = require 'rimraf'
JSONStream = require 'JSONStream'
es = require 'event-stream'
require('datejs')

# lets improve this ..
inputFolder = process.argv[2]
outputFolder = process.argv[3]
indexName = process.argv[4]
typeName = process.argv[5]
bulkSize = process.argv[6]
nbFiles = process.argv[7]
indexType = process.argv[8]   # "daily" / "single" / "none" (default single)


console.log "using input #{inputFolder}"

getStream =  (file) ->
  stream = fs.createReadStream(file, {encoding: 'utf8'})
  parser = JSONStream.parse('*')
  return stream.pipe(parser)


lineCount = 0
bulkCount = 0
rimraf outputFolder, (err) ->    
  mkdirp outputFolder,(err) ->
    
    fs.readdir inputFolder, (err,files) ->
      console.log "processing #{files} #{err}"
      for aFile in files when !fs.lstatSync("#{inputFolder}/#{aFile}").isDirectory() and aFile.indexOf("gz")<0 and aFile.substring(0,1) isnt "."
        console.log "converting #{aFile} #{}..." 
       
        getStream("#{inputFolder}/#{aFile}").pipe es.mapSync (obj) ->

          throw err if err
          
          lineCount++
          
          indexOutputName = indexName
          if indexType is "daily"
            
            #"timestamp":"22/Aug/2015:23:13:42 +0000" obj.timestamp
            dateWork =  obj.timestamp
            myRegexp = /([^:]*):(.*)\s/g
            match = myRegexp.exec(dateWork)
            #console.log "matched #{match[1]} === #{match[2]} "
            datePart = Date.parse( match[1], 'dd/MMM/yyyy')
            timePart = Date.parse( match[2], 'HH:mm:ss')
            # logstash-%{+YYYY.MM.dd}
            indexOutputName = "#{indexName}-#{datePart.toString('yyyy.MM.dd')}"

          indexLine = "{ \"index\" : { \"_index\" : \"#{indexOutputName}\", \"_type\" : \"#{typeName}\" } }"
          
          outputFileName = "file_#{bulkCount}"
          
          # switch to next file when reached bulksize
          if lineCount >= bulkSize
            #fs.renameSync "#{outputFolder}/#{outputFileName}","#{outputFolder}/#{outputFileName}.txt"
            bulkCount++
            if nbFiles>0 and bulkCount >= nbFiles
              console.log "#{bulkCount} reached ..  Stopping !"
              process.exit()
              
            console.log "creating file_#{bulkCount}.txt #{lineCount} lines"
            lineCount=0
         
          outputFileName = "file_#{bulkCount}.txt"

          if indexType is "none"
            result = "#{JSON.stringify(obj)}\n"
          else
            result = "#{indexLine}\n#{JSON.stringify(obj)}\n"
          
          fs.appendFile  "#{outputFolder}/#{outputFileName}", result,  (err) ->
            throw err if err
  