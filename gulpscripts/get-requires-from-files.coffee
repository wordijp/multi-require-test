_  = require 'lodash'
fs = require 'fs'

astRequireParser = require('./ast-parser').astRequireParser

# require‚µ‚Ä‚¢‚émoduleˆê——‚ð“Ç‚Ýž‚ÝA•Ô‚·
getRequiresFromFiles = (files) ->
  requires = []
  for x in files
    data = fs.readFileSync(x)
    astRequireParser(data, (require) ->
      requires.push(require)
    )
  _.uniq(requires)

module.exports = getRequiresFromFiles
