# Description:
#
# Notes:
#

module.exports = (robot) ->
  robot.hear /pwd/i, (res) ->
    working_dir = process.cwd()
    res.reply "#{working_dir}"
