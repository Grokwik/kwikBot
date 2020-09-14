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
jsonLoader = require '../libs/jsonLoader'
jsonCal = new jsonLoader.JsonLoader('autosys_calendars.json')
currentJson = new jsonLoader.JsonLoader('autosys_scripts.json')

calDesc = (calendrier, res) ->
        description = cur_cal.description for cur_cal in jsonCal.data when cur_cal.name is calendrier
        if not description
            res.reply "ERROR :: Unkown calendar :("
            res.reply "--------------------------------------------------------------"
            return
        res.reply "===>  "+calendrier+"  <==="
        res.reply "Description : #{description}"
        res.reply "--------------------------------------------------------------"

getCalledScript = (as_script) ->
        return script.called_script for script in currentJson.data when script.as_script is as_script

calledScriptFromFullASScript = (full_as_script) ->
        scripts = []
        scripts.push script.called_script for script in currentJson.data when -1 isnt full_as_script.indexOf script.as_script
        return scripts[0]

module.exports = (robot) ->
    robot.hear /(.*) (cal|calendrier|calendar) desc/i, (res) ->
        calendrier = res.match[1]
        calDesc calendrier, res

    robot.hear /(calendriers|calendars)$/i, (res) ->
        res.reply ""
        res.reply "Les calendriers référencés sont :"
        res.reply "#{cur_cal.name} : #{cur_cal.description}" for cur_cal in jsonCal.data

    robot.hear /(.*) called/i, (res) ->
        pattern = res.match[1]
        scripts = []
        scripts.push script for script in currentJson.data when -1 isnt script.called_script.indexOf pattern
        scripts.sort()
        res.reply ""
        res.reply script.as_script+" ==> "+script.called_script for script in scripts

    # Still working but useless since it's now included in the "desc" command of the jobs
    # (hence the export of the "getCalledScript" method)
    robot.hear /(.*) (call|calls)$/i, (res) ->
        res.reply getCalledScript res.match[1]

module.exports.calDesc = calDesc
module.exports.getCalledScript = getCalledScript
module.exports.calledScriptFromFullASScript = calledScriptFromFullASScript
