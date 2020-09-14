# Description:
#
# Notes:
#
'use strict'

module.exports = (robot) ->
  robot.hear /pwd/i, (res) ->
    working_dir = process.cwd()
    res.reply "#{working_dir}"

module.exports.typeIsArray = (value) ->
    value and
        typeof value is 'object' and
        value instanceof Array and
        typeof value.length is 'number' and
        typeof value.splice is 'function' and
        not (value.propertyIsEnumerable 'length')
