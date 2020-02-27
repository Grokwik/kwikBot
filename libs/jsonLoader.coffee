# Description:
#
# Note
#
#use strict
fs = require 'fs'

#module.exports.load = (fname) ->
#    data_file = process.cwd()+"\\data\\"+fname
    #console.log "loading "+data_file+"..."
#    fs.exists data_file, (exists) ->
#        if !exists
#            console.log "File #{fname} doesn't exist"
#            return ""
    #console.log "lines loaded : "+data_file.length
#    require data_file

#module.exports = (robot) ->
#  robot.hear /pwd/i, (res) ->
#    working_dir = process.cwd()
#    res.reply "#{working_dir}"

class @JsonLoader
    constructor: (filename) ->
        @filename = filename
        @data_file = process.cwd()+"\\data\\"+filename
        fs.exists @data_file, (exists) ->
            if !exists
                console.log "The file #{@filename} doesn't exist"
                return ""
        @data = require @data_file
