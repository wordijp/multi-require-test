esprima = require('esprima')
traverse = require('ordered-ast-traverse')

# require�\����
predicateRequire = (node) ->
  if (node.type != 'CallExpression' || node.callee.type != 'Identifier' || node.callee.name != 'require')
    return false
  true

# data���p�[�X���Apredicate�ƈ�v���镔����cb�ւƓn��
# @param data      : �p�[�X�Ώۃf�[�^
# @param predicate : �Ƃ���\���Ƃ̃`�F�b�J�[
# @param cb        : ��v����������������󂯎��R�[���o�b�N
astParser = (data, predicate, cb) ->
  traverse(esprima.parse(data, {range: true}), {pre: (node, parent, prop, idx) ->
    if (predicate(node))
      pth = node.arguments[0].value
      if (pth)
        cb(pth)
  })

astRequireParser = (data, cb) -> astParser(data, predicateRequire, cb)

module.exports =
  astRequireParser: astRequireParser
