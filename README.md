# �T�v

���̃v���W�F�N�g�́Agulp & Browserify�\����node_modules�ȊO��module��require����ׂ̃T���v���v���W�F�N�g�ł��B
�ȉ���module���A�����̃p�b�P�[�W�Ǘ��A�p�b�P�[�W�Ǘ��O����require���Ă��܂��B

```coffee:app.coffee
$ = require('jquery')        # ��ǂ���require������
_ = require('underscore')    # Bower�z������require������
Enumerable = require('linq') # node_modules�z������require������
```

# Usage

```
npm install
bower install
gulp (build | clean)
```

## node_modules�ȊO��require�Ή����@

node_modules�ȊO��require�Ή��́A[browserify-maybe-multi-require](https://github.com/wordijp/browserify-maybe-multi-require)�𗘗p���Ă��܂��B

�����browserify.plugin�ɐݒ�l�ƂƂ��ɓn����bundle���鎖�ɂ��Anode_modules�ȊO��module��require���鎖���o���܂��B

```coffee:gulpfile.coffee
entries = ['./lib/scripts/app.js']
b = browserify(entries)
b.plugin('browserify-maybe-multi-require', {
  require: ['*', './non_package_modules/jquery-2.1.3.js:jquery']
  getFiles: () -> entries # ���̃t�@�C���ꗗ����require���Ă���module�ꗗ���擾���A
                          # �v���O�C��������b.require���Ă���
})
```

# �t�@�C���\��

```
root
������ gulpscripts                        - gulp�p�X�N���v�g�u����
|   ������ ast-parser.coffee              - �R�[�h�̃p�[�X�������s��(get-requires-from-files�Ŏg��)
|   ������ get-requires-from-files.coffee - �t�@�C������require��������擾����
|   ������ gulp-callback.coffee           - gulp�̃X�g���[���̗��ꂩ��callback���Ă�
|   ������ to-relative-path.coffee        - ��΃p�X�𑊑΃p�X��
������ bower.json          - Bower�p�b�P�[�W
������ package.json        - node�p�b�P�[�W
������ non_package_modules - ���module
|   ������ jquery-2.1.3.js - (�����ăp�b�P�[�W�Ǘ������Ă��Ȃ�)
������ gulpsfile.coffee - gulp���C��
```

# Licence

MIT
