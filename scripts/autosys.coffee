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
fs = require 'fs'

module.exports = (robot) ->
  robot.hear /calendrier (.*)/i, (res) ->
    data_file = process.cwd()+'/data/autosys_calendars.json'
    calendrier = res.match[1]

    fs.exists data_file, (exists) ->
      if !exists
        return
      json = require data_file
      description = cur_cal.description for cur_cal in json when cur_cal.name is calendrier
#      description = "inconnu" if description?
      res.reply "La description du calendrier #{calendrier} est #{description}"

  robot.hear /calendriers/i, (res) ->
    data_file = process.cwd()+'/data/autosys_calendars.json'

    fs.exists data_file, (exists) ->
      if !exists
        return
      json = require data_file
      res.reply "Les calendriers référencés sont :"
      res.reply "#{cur_cal.name} : #{cur_cal.description}" for cur_cal in json
