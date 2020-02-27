# Description:
#   Tries to recognize an autosys job/box/calendar and launch the desired command
#
# Dependencies:
#   triaplat.coffee
#   autosys.coffee
#
# Configuration:
#   None needed
#
'use strict'
tap = require '../scripts/triaplat'
autosys = require '../scripts/autosys'
refCft = require '../scripts/ReferentielCft'

module.exports = (robot) ->
    robot.hear /IDEOP02-[^E-]{2}[0-9A-Z_]*/i, (res) ->
        robot.brain.set 'jobType', 'JOB'

    robot.hear /IDEOP02-E-[0-9A-Z_]*/i, (res) ->
        robot.brain.set 'jobType', 'CAL'

    robot.hear /[A-Z0-9]{8}/i, (res) ->
        robot.brain.set 'jobType', 'IDF'

    robot.hear /(.*) (desc|description|details)/i, (res) ->
        jobType = robot.brain.get('jobType') or 'UNKNOWN'
        if "JOB" is jobType
            tap.jobDesc res.match[1], res
        else if "CAL" is jobType
            autosys.calDesc res.match[1], res
        else if "IDF" is jobType
            refCft.cftDesc res.match[1], res
        else
            res.reply "I don't recognize the type of data you're looking for :/"
        robot.brain.set 'jobType', 'UNKNOWN'
