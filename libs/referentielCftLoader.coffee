#
# Description:
# Note
#
'use strict'
fs = require 'fs'

csvContent = ''
dataArray = []

lineToObject = (line) ->
    result = line.split ";"
    return false if result is null or result[1] is undefined
    output =
         category:result[0]
         idf:result[1]
         directory:result[2]
         file:result[3]
         jobset:result[4]
         job:result[5]
         earlytime:result[6]
         abendaction:result[7]
         jobsetpred:result[8]
         jobpred:result[9]
         trigger:result[10]
         calendar:result[11]
         part:result[12]
         par:result[13]
    dataArray.push output
    return true

csvToJson = () ->
    allLines = (csvContent.split "\n")[1..]
    lineToObject line for line in allLines when line[0] isnt '#'

loadFile = (filename) ->
    exactname = process.cwd()+"\\data\\"+filename
    fs.exists exactname, (exists) ->
        if !exists
            console.log "File #{filename} doesn't exist"
            return
    filename = process.cwd()+"\\data\\ReferentielCft.csv"
    data = fs.readFileSync filename
    csvContent = data.toString()

module.exports.toJson = (fname) ->
    loadFile fname
    csvToJson ""

module.exports.convertedData = dataArray
