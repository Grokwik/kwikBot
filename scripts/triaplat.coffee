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
    #console.log "lines loaded : "+data_file.length
    require data_file

json = loadDataFromJson 'triaplat.json'

getJob = (exactname) ->
    foundJob = cur_job for cur_job in json when exactname is cur_job.jobname
    return if foundJob? then foundJob else false

displayJob = (foundJob, res) ->
    if not foundJob
        res.reply "Unkown job :("
        return
    res.reply "Description   : "+foundJob.description unless 0 is foundJob.description.length
    res.reply "Box           : "+foundJob.box_name unless 0 is foundJob.box_name.length
    res.reply "Type          : "+foundJob.job_type
    res.reply "Calendar      : "+foundJob.run_calendar unless 0 is foundJob.run_calendar.length
    res.reply "Start time    : "+foundJob.start_times unless 0 is foundJob.start_times.length
    res.reply "Condition     : "+foundJob.condition unless 0 is foundJob.condition.length
#    res.reply "Owner         : "+foundJob.owner
    res.reply "Command       : "+foundJob.command unless 0 is foundJob.command.length
    res.reply "Machine       : "+foundJob.alias_machine unless 0 is foundJob.alias_machine.length
    res.reply "Run window    : "+foundJob.run_window unless 0 is foundJob.run_window.length
#    res.reply "Alarm if fail : "+foundJob.alarm_if_fail unless 0 is foundJob.alarm_if_fail.length

module.exports = (robot) ->
    ################################################################################
    ## LISTINGS ####################################################################
    ################################################################################
    robot.hear /jobs$/i, (res) ->
        res.reply ""
        res.reply cur_job.jobname for cur_job in json when "CMD" is cur_job.job_type
        res.reply "--------------------------------------------------------------"

    robot.hear /(file transferts|file transfers|fts)$/i, (res) ->
        res.reply ""
        res.reply cur_job.jobname for cur_job in json when "FT" is cur_job.job_type
        res.reply "--------------------------------------------------------------"

    robot.hear /(boxes|boxs)/i, (res) ->
        res.reply ""
        res.reply cur_job.jobname for cur_job in json when "BOX" is cur_job.job_type
        res.reply "--------------------------------------------------------------"

    robot.hear /jobs like (.*)/i, (res) ->
        pattern = res.match[1]
        jobs = []
        jobs.push cur_job.jobname for cur_job in json when -1 isnt cur_job.jobname.indexOf pattern
        jobs.sort()
        res.reply "==> Jobs looking like #{pattern} <=="
        res.reply jobname for jobname in jobs
        res.reply "--------------------------------------------------------------"

    ################################################################################
    ## SEARCHES ####################################################################
    ################################################################################
    robot.hear /jobs by calendar (.*)/i, (res) ->
        calendar = res.match[1]
        res.reply "==> The following jobs are following the calendar #{calendar} <=="
        res.reply cur_job.jobname for cur_job in json when calendar is cur_job.run_calendar
        res.reply "--------------------------------------------------------------"
    #
    ################################################################################
    ## DETAILS #####################################################################
    ################################################################################
    robot.hear /(.*) (triggers|declenche|déclenche)/i, (res) ->
        trigger = res.match[1]
        res.reply "==> The job #{trigger} triggers the following jobs <=="
        res.reply cur_job.jobname for cur_job in json when -1 isnt cur_job.condition.indexOf trigger
        res.reply "--------------------------------------------------------------"

    robot.hear /(.*) (childs|kids)/i, (res) ->
        father = res.match[1]
        res.reply "==> Here are the #{father} job's childs <=="
        res.reply cur_job.jobname for cur_job in json when father is cur_job.box_name
        res.reply "--------------------------------------------------------------"

    robot.hear /(.*) job (desc|description|details)/i, (res) ->
        exactname = res.match[1]
        foundJob = getJob exactname
        if not foundJob
            res.reply "ERROR :: Unkown job :("
            res.reply "--------------------------------------------------------------"
            return
        res.reply "===>  "+foundJob.jobname+"  <==="
        displayJob(foundJob,res)
        res.reply "--------------------------------------------------------------"

    robot.hear /(.*) (family|audit)/i, (res) ->
        jobname = res.match[1]
        res.reply ""
        foundJob = getJob jobname
        if not foundJob
            res.reply "ERROR :: Unkown job :("
            return

        parent = getJob foundJob.box_name
        if parent
            grandParent = getJob parent.box_name

        res.reply "--------------------------------------------------------------"
        if grandParent
            res.reply "===> GRAND PARENT : "+grandParent.jobname
            res.reply "--------------------------------------------------------------"
            displayJob(grandParent,res)
            res.reply "--------------------------------------------------------------"
        if parent
            res.reply "===> PARENT : "+parent.jobname
            res.reply "--------------------------------------------------------------"
            displayJob(parent,res)
            res.reply "--------------------------------------------------------------"
        res.reply "===> JOB       : "+foundJob.jobname
        res.reply "--------------------------------------------------------------"
        displayJob(foundJob,res)
        res.reply "--------------------------------------------------------------"
