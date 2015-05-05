_  = require 'lodash'
fs = require 'fs'

astRequireParser = require('./ast-parser').astRequireParser

# require���Ă���module�ꗗ��ǂݍ��݁A�Ԃ�
getRequiresFromFiles = (files) ->
  requires = []
  for x in files
    data = fs.readFileSync(x)
    astRequireParser(data, (require) ->
      requires.push(require)
    )
  _.uniq(requires)

module.exports = getRequiresFromFiles
