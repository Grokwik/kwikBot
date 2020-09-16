'use strict'

module.exports.getMemory = (brain) ->
    mem = brain.get('MEMORY') or ""
    return mem

module.exports.memorize = (brain, value) ->
    brain.set 'MEMORY', value
