## Description
#   Displays the referenced c_id for a given contributor.
#   The C_IDs are listed in the Hubot's /data/CIDS.json file
#
## Note
#   The CIDS.json file has the following format :
#
#   [{
#     "contrib": "markit",
#     "c_ids": [
#       { "value": "MA_GENE_CDS" },
#       { "value": "MA" },
#       { "value": "MA_CONTR_CDS" },
#       { "value": "MA_FLUX_CDS" }
#     ]
#   }, {
#    "contrib": "moodys",
#    "c_ids" : ...
#  ]

'use strict'
jsonLoader = require '../libs/jsonLoader'
json = new jsonLoader.JsonLoader('CIDS.json').data

module.exports = (robot) ->
  robot.hear /(.*) c_ids/i, (res) ->
    contributeur = res.match[1]
    all_cids = cur_contrib.c_ids for cur_contrib in json when cur_contrib.contrib is contributeur
    referenced_cids = true if all_cids?
    if not referenced_cids
        res.reply "Il n'y a aucun C_ID référencés pour #{contributeur}... Désolé"
        return
    res.reply "Voici le(s) C_ID référencés pour #{contributeur} :"
    res.reply cid.value for cid in all_cids


  robot.hear /contribs/i, (res) ->
      res.reply "Voici tous contributeurs référencés :"
      res.reply "#{cur_contrib.contrib} a #{cur_contrib.c_ids.length} C_IDs" for cur_contrib in json
