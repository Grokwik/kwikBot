# Description:
#   Displays all the developped commands
#
# Note
#   (!) Must be updated manually (!)

'use strict'

module.exports = (robot) ->
    robot.hear /(help|aide|\?|--help|-h)/i, (res) ->
        res.reply ""
        res.reply "===== TRIAPLAT related stuff =============================="
        res.reply ""
        res.reply "jobs                : List all the jobs"
        res.reply "fts                 : List all the file transfers"
        res.reply "                    : aliases : file transfers, file transferts"
        res.reply "boxes               : List all the boxes"
        res.reply "                    : aliases : boxs"
        res.reply "jobs like XX        : Lists all the jobs whose name are containing XX"
        res.reply "XX job desc         : Displays the description of the job named XX"
        res.reply "                    : aliases : job description,job details"
        res.reply "XXX triggers        : List the jobs that are in the starting condition of the job XX"
        res.reply "                    : aliases : declenche, déclenche"
        res.reply "XXX childs          : List all the jobs whose box is XX"
        res.reply "                    : aliases : XX kids"
        res.reply "jobs by calendar XX : List all the jobs whose calender is XX"
        res.reply "XX family           : Displays the while job hierarchy for the XX job (with the details for each job)"
        res.reply "                    : aliases : XX audit"
        res.reply ""
        res.reply "===== AUTOSYS related stuff =============================="
        res.reply ""
        res.reply "calendars           : List all the autosys calendars"
        res.reply "                    : aliases : calendriers"
        res.reply "XX calendar desc    : Displays the XXX calendar's description"
        res.reply "                    : aliases : XX cal desc, XX calendrier desc"
        res.reply "XX call             : Displays the script called by the autosys script XX"
        res.reply "                    : aliases : XX calls"
        res.reply "XX called           : Displays the autosys script that contains the XX chain in its called script"
        res.reply ""
        res.reply "===== ISL related stuff =================================="
        res.reply ""
        res.reply "XX c_ids            : List all the contributor's registered C_IDs"
        res.reply "                    : aliases : calendriers"
        res.reply "contribs            : List of contributors that are registered"
        res.reply ""
        res.reply "===== SQL related stuff =================================="
        res.reply ""
        res.reply "sql list            : List all the registered SQL requests"
        res.reply "                    : aliases : ls"
        res.reply "sql get XX          : Displays the XX SQL request"
        res.reply "                    : aliases : gimme, display"
