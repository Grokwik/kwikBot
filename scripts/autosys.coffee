# Description:
#   Returns the description of an autosys calender as referenced in the <Hubot_home>/data/autosys_calendars.json file
#
# Note
#   The autosys_calendars.json file has the following format :
# [
#   { "name":"IDEOP02-E-CAL_DI1", "description":"Le 1 dimanche du mois"},
#   { "name":"IDEOP02-E-CAL_DI2", "description":"Le 2ème  dimanche du mois "},
#   ...
# ]
#
'use strict'
fs = require 'fs'

loadDataFromJson = (fname) ->
    data_file = process.cwd()+"\\data\\"+fname
    #console.log "loading "+data_file+"..."
    fs.exists data_file, (exists) ->
        if !exists
            console.log "File doesn't exist"
            return ""
    #console.log "lines loaded : "+data_file.length
    require data_file

json = loadDataFromJson 'autosys_calendars.json'

module.exports = (robot) ->
    robot.hear /(calendrier|calendar) (.*) desc/i, (res) ->
        calendrier = res.match[2]
        description = cur_cal.description for cur_cal in json when cur_cal.name is calendrier
#        description = "inconnu" if description?
        res.reply ""
        res.reply "La description du calendrier #{calendrier} est #{description}"

    robot.hear /(calendriers|calendars)$/i, (res) ->
        res.reply ""
        res.reply "Les calendriers référencés sont :"
        res.reply "#{cur_cal.name} : #{cur_cal.description}" for cur_cal in json

    robot.hear /(.*) (call|calls)$/i, (res) ->
        as_script = res.match[1]
        res.reply script.called_script for script in json when script.as_script is as_script

    robot.hear /(.*) called/i, (res) ->
        pattern = res.match[1]
        scripts = []
        scripts.push script for script in json when -1 isnt script.called_script.indexOf pattern
        scripts.sort()
        res.reply ""
        res.reply script.as_script+" ==> "+script.called_script for script in scripts
