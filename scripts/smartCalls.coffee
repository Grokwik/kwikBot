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

getType = (str, res) ->
    if /^IDEOP02-E-[0-9A-Z-_]*$/i.test(str)
        return "CAL"
        # res.reply "it's a CAL"
    else if /^IDEOP02-[0-9A-Z-_]*$/i.test(str)
        return "JOB"
        # res.reply "it's a JOB"
    else if /^[A-Z0-9^-]{8}$/i.test(str)
        return "IDF"
        # res.reply "it's an IDF"
    else
        return "UNKOWN"
        # res.reply "Who knows what it is..."

module.exports = (robot) ->
#    robot.hear /test (.*)/i, (res) ->
#        getType(res.match[1], res)

    robot.hear /(.*) (desc|description|details)/i, (res) ->
        #jobType = robot.brain.get('jobType') or 'UNKNOWN'
        jobType = getType(res.match[1], res)
        if "JOB" is jobType
            tap.jobDesc res.match[1], res
        else if "CAL" is jobType
            autosys.calDesc res.match[1], res
        else if "IDF" is jobType
            refCft.cftDesc res.match[1], res
        else
            res.reply "I don't recognize the type of data you're looking for :/"
         #robot.brain.set 'jobType', 'UNKNOWN'
