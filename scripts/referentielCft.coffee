# Description:
#
# Note
#   The referentielCft.csv file has the following format :
# [
#   { "name":"IDEOP02-E-CAL_DI1", "description":"Le 1 dimanche du mois"},
#   { "name":"IDEOP02-E-CAL_DI2", "description":"Le 2ème  dimanche du mois "},
#   ...
# ]
#
'use strict'
refCftLoader = require '../libs/referentielCftLoader'
refCftLoader.toJson('ReferentielCft.csv')
jsonRefCft = refCftLoader.convertedData

getCft = (idf) ->
    foundCft = cur_cft for cur_cft in jsonRefCft when idf is cur_cft.idf
    return if foundCft? then foundCft else false

displayCft = (foundCft, res) ->
    if not foundCft
        res.reply "Unkown Cft :("
        return
    res.reply "Category    : "+foundCft.category unless 0 is foundCft.category.length
    res.reply "IDF         : "+foundCft.idf unless 0 is foundCft.idf.length
    res.reply "Directory   : "+foundCft.directory unless 0 is foundCft.directory.length
    res.reply "File        : "+foundCft.file unless 0 is foundCft.file.length
    res.reply "Jobset      : "+foundCft.jobset.toUpperCase() unless 0 is foundCft.jobset.length
    res.reply "job         : "+foundCft.job.toUpperCase() unless 0 is foundCft.job.length
    res.reply "earlytime   : "+foundCft.earlytime unless 0 is foundCft.earlytime.length
    res.reply "abendaction : "+foundCft.abendaction unless 0 is foundCft.abendaction.length
    res.reply "jobsetpred  : "+foundCft.jobsetpred unless 0 is foundCft.jobsetpred.length
    res.reply "jobpred     : "+foundCft.jobpred unless 0 is foundCft.jobpred.length
    res.reply "trigger     : "+foundCft.trigger unless 0 is foundCft.trigger.length
    res.reply "calendar    : "+foundCft.calendar unless 0 is foundCft.calendar.length
    res.reply "part        : "+foundCft.part unless 0 is foundCft.part.length
    res.reply "par         : "+foundCft.par unless 0 is foundCft.par.length

cftDesc = (idf, res) ->
    foundCft = getCft idf
#    if not foundCft
#        res.reply "ERROR :: Unkown CFT :("
#        res.reply "--------------------------------------------------------------"
#        return
    res.reply "===>  "+foundCft.idf+"  <==="
    displayCft(foundCft,res)
    res.reply "--------------------------------------------------------------"

Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

module.exports = (robot) ->
    ################################################################################
    ## LISTINGS ####################################################################
    ################################################################################
    robot.hear /^cft(s| ids)$/i, (res) ->
        res.reply cur_cft.idf for cur_cft in jsonRefCft
        #res.reply cur_cft.﻿jobname for cur_cft in refCft
        # when "CMD" is cur_job.job_type
        res.reply "--------------------------------------------------------------"

    robot.hear /cfts like (.*)/i, (res) ->
        pattern = res.match[1]
        cfts = []
        cfts.push cur_cft.idf for cur_cft in jsonRefCft when -1 isnt cur_cft.idf.indexOf pattern
        cfts.sort()
        res.reply "==> Cfts looking like #{pattern} <=="
        res.reply idf for idf in cfts
        res.reply "--------------------------------------------------------------"

    robot.hear /(.*) cft (desc|description|details)/i, (res) ->
        cftDesc(res.match[1], res)

    robot.hear /cft sending (.*)/i, (res) ->
        filename = res.match[1]
        cfts = []
        cfts.push cur_cft.idf for cur_cft in jsonRefCft when -1 isnt cur_cft.file is filename
        cfts.sort()
        res.reply "==> Cfts sending the file #{filename} <=="
        res.reply idf for idf in cfts
        res.reply "--------------------------------------------------------------"

    robot.hear /cft categories/i, (res) ->
        categories = []
        categories.push cur_cft.category for cur_cft in jsonRefCft
        categories = categories.unique().sort()
        res.reply cur_category for cur_category in categories

    robot.hear /cft from category (.*)/i, (res) ->
        category = res.match[1]
        cfts = []
        cfts.push cur_cft.idf for cur_cft in jsonRefCft when -1 isnt cur_cft.category is category
        cfts.sort()
        res.reply "==> Cfts with the category #{category} <=="
        res.reply idf for idf in cfts
        res.reply "--------------------------------------------------------------"

    robot.hear /(help|aide|\?)/i, (res) ->
        res.reply ""
        res.reply "===== IDF (referentielCft) ==============================="
        res.reply "cft ids              : List all the referentielCft's IDFs"
        res.reply "                     : aliases : cfts"
        res.reply "cft like XX          : Lists all the IDF that are containing XX"
        res.reply "XX cft desc          : Displays the description of the CFT named XX"
        res.reply "                     : aliases : cft description,cft details"
        res.reply "cft sending XX       : Lists all the IDFs that are sending the file XX"
        res.reply "cft categories       : Lists all the different referentielCft file' categories"
        res.reply "cft from category XX : Lists all the IDFs with the category XX"

module.exports.cftDesc = cftDesc
module.exports.jsonRefCft = jsonRefCft
module.exports.getCft = getCft
#module.exports.envSwitch = envSwitch
