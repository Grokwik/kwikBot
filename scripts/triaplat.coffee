# Description:
#   Commands used to look for informations in the triaplat
#
# Note
#   The triaplat.json file has the following format :
#   [
#    {
#      "jobname": "IDEOP02-H2SAV01-SAVEORA-P01188AP10-FULL",
#      "job_type": "CMD",
#      "owner": "oracle",
#      "start_times": "",
#      "alarm_if_fail": "1",
#      "box_name": "IDEOP02-H1BOX-SAVEORA-P01188AP10",
#      "command": "/apps/exploit/autosys/DEOP02/script/IDEOP02-H2SAV01-SAVEORA-P01188AP10-FULL.ksh",
#      "alias_machine": "s00va9943923",
#      "condition": "",
#      "run_calendar": "",
#      "description": "Sauvegarde FULL de l instance P01188AP10",
#      "run_window": ""
#    },
#    {
#      "jobname": "IDEOP02-H2SAV01-SAVEORA-P01188AS10-FULL",
#      "job_type": "CMD",
#      (...)
'use strict'
fs = require 'fs'

loadDataFromJson = (fname) ->
    data_file = process.cwd()+"\\data\\"+fname
    #console.log "loading "+data_file+"..."
    fs.exists data_file, (exists) ->
        if !exists
            console.log "File doesn't exist"
            return ""
    #console.log "lines loaded : "+json.length
    require data_file

module.exports = (robot) ->
    robot.hear /tap (help|aide|\?|--help|-h)/i, (res) ->
        res.reply ""
        res.reply "tap jobs        : List all the jobs"
        res.reply "tap boxes       : List all the boxes"
        res.reply "tap like XX     : Lists all the jobs whose name are containing XX"
        res.reply "                : aliases : search, cherche, recherche"
        res.reply "tap desc XX     : Displays the description of the job named XX"
        res.reply "                : aliases : description, details"
        res.reply "tap triggers XX : List the jobs that are triggered by the success of the job XX"
        res.reply "                : aliases : declenche, déclenche"
        res.reply "tap childs XX   : List all the jobs whose box is XX"
        res.reply "                : aliases : fils, filles, enfants, descendants, descendantes"

    robot.hear /tap jobs/i, (res) ->
        json = loadDataFromJson 'triaplat.json'
        res.reply ""
        res.reply cur_job.jobname for cur_job in json # when cur_job.contrib is contributeur

    robot.hear /tap boxes/i, (res) ->
        json = loadDataFromJson 'triaplat.json'
        res.reply ""
        res.reply cur_job.jobname for cur_job in json when "BOX" is cur_job.job_type

    robot.hear /tap (like|search|cherche|recherche) (.*)/i, (res) ->
        pattern = res.match[2]
        json = loadDataFromJson 'triaplat.json'
        res.reply ""
        res.reply cur_job.jobname for cur_job in json when -1 isnt cur_job.jobname.indexOf pattern

    robot.hear /tap (triggers|declenche|déclenche) (.*)/i, (res) ->
        trigger = res.match[2]
        json = loadDataFromJson 'triaplat.json'
        res.reply ""
        res.reply cur_job.jobname for cur_job in json when -1 isnt cur_job.condition.indexOf trigger

    robot.hear /tap (childs|fils|filles|enfants|descendants|descendantes) (.*)/i, (res) ->
        father = res.match[2]
        json = loadDataFromJson 'triaplat.json'
        res.reply ""
        res.reply cur_job.jobname for cur_job in json when father is cur_job.box_name

    robot.hear /tap (desc|description|details) (.*)/i, (res) ->
        exactname = res.match[2]
        json = loadDataFromJson 'triaplat.json'
        foundJob = cur_job for cur_job in json when exactname is cur_job.jobname
        found = true if foundJob?
        if not found
            res.reply "Unkown job :("
            return
        res.reply ""
        res.reply "===>  "+foundJob.jobname+"  <==="
        res.reply "Description   : "+foundJob.description
        res.reply "Box           : "+foundJob.box_name
        res.reply "Type          : "+foundJob.job_type
        res.reply "Calendar      : "+foundJob.run_calendar
        res.reply "Start time    : "+foundJob.start_times
        res.reply "Condition     : "+foundJob.condition
        res.reply "Owner         : "+foundJob.owner
        res.reply "Command       : "+foundJob.command
        res.reply "Machine       : "+foundJob.alias_machine
        res.reply "Run window    : "+foundJob.run_window
        res.reply "Alarm if fail : "+foundJob.alarm_if_fail
