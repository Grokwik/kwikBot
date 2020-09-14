# Description:
#
# Note
#
'use strict'
monitoringLoader = require '../libs/csvMonitoringLoader'
monitoringLoader.toJson('monitoring.csv')
json = monitoringLoader.convertedData

getMonitoringData = (jobName) ->
    foundMonitoring = cur_monitoring for cur_monitoring in json when jobName is cur_monitoring.job
    return foundMonitoring

displayMonitoringData = (foundMonitoring, res) ->
    if not foundMonitoring
        res.reply "Unkown job :("
        return
    res.reply "Job          : "+foundMonitoring.job
    res.reply "Traitement   : "+foundMonitoring.traitement unless 0 is foundMonitoring.traitement.length
    res.reply "Step         : "+foundMonitoring.step unless 0 is foundMonitoring.step.length
    res.reply "Description  : "+foundMonitoring.description unless 0 is foundMonitoring.description.length
    res.reply "C_IDs        : "+foundMonitoring.c_id unless 0 is foundMonitoring.c_id.length
    res.reply "Ok ko file   : "+foundMonitoring.okko unless 0 is foundMonitoring.okko.length
    res.reply "Log          : "+foundMonitoring.log unless 0 is foundMonitoring.log.length

module.exports = (robot) ->
    robot.hear /(.*) monitoring/i, (res) ->
        foundMonitoring = getMonitoringData res.match[1]
        displayMonitoringData(foundMonitoring, res)

#    robot.hear /^monitorings$/i, (res) ->
#        res.reply cur_monitoring.job for cur_monitoring in json

module.exports.getMonitoringData = getMonitoringData
