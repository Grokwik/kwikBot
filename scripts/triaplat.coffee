# Description:
#   Commands used to look for informations in the triaplat
#
'use strict'

triaplatLoader = require '../libs/csvTriaplatLoader'
triaplatLoader.toJson('triaplat.csv')
triaplatjson = triaplatLoader.convertedData

autosys = require '../scripts/autosys'
monitoring = require '../scripts/monitoring'
robotMemory = require '../scripts/memory'

getJob = (exactname) ->
    foundJob = cur_job for cur_job in triaplatjson when exactname is cur_job.jobname
    return if foundJob? then foundJob else false

displayJob = (foundJob, res) ->
    if not foundJob
        res.reply "Unkown job :("
        return
    res.reply "Name          : "+foundJob.jobname unless 0 is foundJob.jobname.length
    res.reply "Description   : "+foundJob.description unless 0 is foundJob.description.length
    res.reply "Box           : "+foundJob.box_name unless 0 is foundJob.box_name.length
    res.reply "Type          : "+foundJob.job_type
    res.reply "Calendar      : "+foundJob.run_calendar unless 0 is foundJob.run_calendar.length
    res.reply "Start time    : "+foundJob.start_times unless 0 is foundJob.start_times.length
    res.reply "Condition     : "+foundJob.condition unless 0 is foundJob.condition.length
    res.reply "Owner         : "+foundJob.owner
    if 0 isnt foundJob.command.length
        res.reply "Command       : "+foundJob.command
        res.reply "Called script : "+autosys.calledScriptFromFullASScript foundJob.command
#    res.reply "Machine       : "+foundJob.alias_machine unless 0 is foundJob.alias_machine.length
    res.reply "Run window    : "+foundJob.run_window unless 0 is foundJob.run_window.length
#    res.reply "Alarm if fail : "+foundJob.alarm_if_fail unless 0 is foundJob.alarm_if_fail.length

    foundMonitoring = monitoring.getMonitoringData foundJob.jobname
    if not foundMonitoring
        return
#    res.reply "Job           : "+foundMonitoring.job
    res.reply "Traitement    : "+foundMonitoring.traitement unless 0 is foundMonitoring.traitement.length
#    res.reply "Step          : "+foundMonitoring.step unless 0 is foundMonitoring.step.length
    res.reply "Description   : "+foundMonitoring.description unless 0 is foundMonitoring.description.length
    res.reply "C_IDs         : "+foundMonitoring.c_id unless 0 is foundMonitoring.c_id.length
    res.reply "Ok ko file    : "+foundMonitoring.okko unless 0 is foundMonitoring.okko.length
    res.reply "Log file      : "+foundMonitoring.log unless 0 is foundMonitoring.log.length

jobDesc = (exactname, res, brain) ->
    foundJob = getJob exactname
    if not foundJob
        res.reply "ERROR :: Unkown job :("
        res.reply "--------------------------------------------------------------"
        return
    res.reply "===>  "+foundJob.jobname+"  <==="
    displayJob(foundJob,res)
    robotMemory.memorize(brain, foundJob)
    res.reply "--------------------------------------------------------------"

getTriggeredJob = (job) ->
    jobs = []
    jobs.push cur_job.jobname for cur_job in triaplatjson when -1 isnt cur_job.condition.indexOf job
    return jobs

displayAllTriggeredJobs = (job, indent, depth, res) ->
    return if depth is 0
    indentation = Array(indent+1).join '....'
    triggeredJobs = getTriggeredJob(job)
    for cur_job in triggeredJobs
        res.reply indent+indentation+" "+cur_job
        displayAllTriggeredJobs(cur_job, indent+1, depth-1, res)

getTriggeredJobs = (trigger, res, brain) ->
    jobs = []
    res.reply "==> The job #{trigger} triggers the following jobs <=="
    jobs.push cur_job for cur_job in getTriggeredJob(trigger)
    jobs.sort()
    if jobs.length is 1
        triggeredJob = getJob(jobs[0])
        displayJob(triggeredJob,res)
        robotMemory.memorize(brain, triggeredJob)
    else
        res.reply cur_job for cur_job in jobs
        res.reply "--------------------------------------------------------------"


module.exports = (robot) ->
    ################################################################################
    ## LISTINGS ####################################################################
    ################################################################################
    robot.hear /jobs$/i, (res) ->
        res.reply ""
        res.reply cur_job.jobname for cur_job in triaplatjson when "CMD" is cur_job.job_type
        res.reply "--------------------------------------------------------------"

    robot.hear /^fts$/i, (res) ->
        res.reply ""
        res.reply cur_job.jobname for cur_job in triaplatjson when "FT" is cur_job.job_type
        res.reply "--------------------------------------------------------------"

    robot.hear /(boxes|boxs)$/i, (res) ->
        res.reply ""
        res.reply cur_job.jobname for cur_job in triaplatjson when "BOX" is cur_job.job_type
        res.reply "--------------------------------------------------------------"

    robot.hear /jobs like (.*)/i, (res) ->
        pattern = res.match[1]
        jobs = []
        jobs.push cur_job for cur_job in triaplatjson when -1 isnt cur_job.jobname.indexOf pattern
        if jobs.length is 1
            displayJob(jobs[0],res)
            robotMemory.memorize(robot.brain, jobs[0])
        else
            res.reply "==> Jobs looking like #{pattern} <=="
            res.reply job.jobname for job in jobs
            res.reply "--------------------------------------------------------------"

    robot.hear /^fts like (.*)/i, (res) ->
        pattern = res.match[1]
        fts = []
        fts.push cur_ft.jobname for cur_ft in triaplatjson when (-1 isnt cur_ft.jobname.indexOf pattern) and ("FT" is cur_ft.job_type)
        fts.sort()
        res.reply "==> FTs looking like #{pattern} <=="
        res.reply jobname for jobname in fts
        res.reply "--------------------------------------------------------------"

    robot.hear /boxes like (.*)/i, (res) ->
        pattern = res.match[1]
        boxes = []
        boxes.push cur_box.jobname for cur_box in triaplatjson when (-1 isnt cur_box.jobname.indexOf pattern) and ("BOX" is cur_box.job_type)
        boxes.sort()
        res.reply "==> BOXs looking like #{pattern} <=="
        res.reply jobname for jobname in boxes
        res.reply "--------------------------------------------------------------"

    ################################################################################
    ## SEARCHES ####################################################################
    ################################################################################
    robot.hear /jobs by calendar (.*)/i, (res) ->
        calendar = res.match[1]
        res.reply "==> The following jobs are following the calendar #{calendar} <=="
        res.reply cur_job.jobname for cur_job in triaplatjson when calendar is cur_job.run_calendar
        res.reply "--------------------------------------------------------------"

    ################################################################################
    ## DETAILS #####################################################################
    ################################################################################
    robot.hear /(.*) (triggers|declenche|déclenche)/i, (res) ->
        getTriggeredJobs res.match[1], res, robot.brain

    robot.hear /^[ \t]*next[ \t]*$/i, (res) ->
        trigger = robotMemory.getMemory(robot.brain)
        getTriggeredJobs trigger.jobname, res, robot.brain

    robot.hear /(.*) (childs|kids)/i, (res) ->
        father = res.match[1]
        res.reply "==> Here are the #{father} job's childs <=="
        res.reply cur_job.jobname for cur_job in triaplatjson when father is cur_job.box_name
        res.reply "--------------------------------------------------------------"

    robot.hear /(.*) job (desc|description|details)/i, (res) ->
        jobDesc(res.match[1], res, brain)

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
            res.reply "===> BOX 0 : "+grandParent.jobname
            res.reply "--------------------------------------------------------------"
            displayJob(grandParent,res)
            res.reply "--------------------------------------------------------------"
        if parent
            res.reply "===> BOX 1 : "+parent.jobname
            res.reply "--------------------------------------------------------------"
            displayJob(parent,res)
            res.reply "--------------------------------------------------------------"
        res.reply "===> JOB       : "+foundJob.jobname
        res.reply "--------------------------------------------------------------"
        displayJob(foundJob,res)
        res.reply "--------------------------------------------------------------"

    robot.hear /(.*) +cascade *([0-9]*)/i, (res) ->
        trigger = res.match[1]
        depth = res.match[2]
        res.reply "==> The job #{trigger} triggers the following jobs <=="
        displayAllTriggeredJobs(trigger, 1, depth, res)
        res.reply "--------------------------------------------------------------"

    robot.hear /(help|aide|\?)/i, (res) ->
        res.reply ""
        res.reply "===== TRIAPLAT related stuff =============================="
        res.reply "jobs                : List all the jobs"
        res.reply "fts                 : List all the file transfers"
        res.reply "boxes               : List all the boxes"
        res.reply "                    : aliases : boxs"
        res.reply "jobs like XX        : Lists all the jobs whose name are containing XX"
        res.reply "fts like XX         : Lists all the fts whose name are containing XX"
        res.reply "boxes like XX       : Lists all the boxes whose name are containing XX"
        res.reply "XX job desc         : Displays the description of the job named XX"
        res.reply "                    : aliases : job description,job details"
        res.reply "XXX triggers        : List the jobs that are in the starting condition of the job XX"
        res.reply "                    : aliases : declenche, déclenche"
        res.reply "XX cascade          : List all the jobs that are in the starting condition of the job XX"
        res.reply "XX cascade Y        : List all the jobs that are in the starting condition of the job XX and do it on Y generations"
        res.reply "XXX childs          : List all the jobs whose box is XX"
        res.reply "                    : aliases : XX kids"
        res.reply "XX family           : Displays the while job hierarchy for the XX job (with the details for each job)"
        res.reply "jobs by calendar XX : List all the jobs whose calender is XX"
        res.reply "next                : Pseudo alias of the 'triggers' command"

module.exports.jobDesc = jobDesc
