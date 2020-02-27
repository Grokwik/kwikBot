# Description:
#   TODO
#
# Note
#   TODO
'use strict'
fs = require 'fs'

jsonLoader = require '../libs/jsonLoader'
json = new jsonLoader.JsonLoader('requetes_sql.json').data

module.exports = (robot) ->
    robot.hear /sql (list|ls)/i, (res) ->
        res.reply ""
        res.reply cur_req.name for cur_req in json

    robot.hear /sql (get|gimme|display) (.*)/i, (res) ->
        sqlname = res.match[2]
        res.reply cur_req.request for cur_req in json when cur_req.name is sqlname
