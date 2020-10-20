## Description
#   Displays the entry point for each contributor (= the first job to be called)
#
## Note

'use strict'
robotMemory = require '../scripts/memory'
jsonLoader = require '../libs/jsonLoader'
currentJson = new jsonLoader.JsonLoader('entries.json')
tap = require '../scripts/triaplat'

module.exports = (robot) ->
    robot.hear /(.*) entry/i, (res) ->
        partner = res.match[1]
        res.reply "===>  "+partner+"  <==="
        jobs = []
        jobs.push cur.job for cur in currentJson.data when cur.partner is partner
        jobs.sort()
        if jobs.length is 1
            tap.jobDesc(jobs[0], res, robot.brain)
        else
            res.reply cur_job for cur_job in jobs

    robot.hear /^entries$/i, (res) ->
        res.reply ""
        res.reply cur.partner+" : "+cur.job for cur in currentJson.data

    robot.hear /(help|aide|\?)/i, (res) ->
        res.reply ""
        res.reply "===== TRIAPLAT related stuff =============================="
        res.reply "entries             : Displays the entry point of all the registered contributors"
        res.reply "XXX entry           : Displays the entry point of the contributor XXX"
