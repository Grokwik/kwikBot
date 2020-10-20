# Description:
#
# Note
#
'use strict'

getMemory = (brain) ->
    mem = brain.get('MEMORY') or ""
    return mem

memorize = (brain, value) ->
    brain.set 'MEMORY', value

module.exports = (robot) ->
    robot.hear /^Easter egg$/i, (res) ->
        res.reply "Have you tried turning it on and off again ?"
module.exports.getMemory = getMemory
module.exports.memorize = memorize
