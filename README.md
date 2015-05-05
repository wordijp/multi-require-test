# 概要

このプロジェクトは、gulp & Browserify構成でnode_modules以外のmoduleもrequireする為のサンプルプロジェクトです。
以下のmoduleを、複数のパッケージ管理、パッケージ管理外からrequireしています。

```coffee:app.coffee
$ = require('jquery')        # 野良からrequireしたい
_ = require('underscore')    # Bower配下からrequireしたい
Enumerable = require('linq') # node_modules配下からrequireしたい
```

# Usage

```
npm install
bower install
gulp (build | clean)
```

## node_modules以外のrequire対応方法

node_modules以外のrequire対応は、[browserify-maybe-multi-require](https://github.com/wordijp/browserify-maybe-multi-require)を利用しています。

これをbrowserify.pluginに設定値とともに渡してbundleする事により、node_modules以外のmoduleもrequireする事が出来ます。

```coffee:gulpfile.coffee
entries = ['./lib/scripts/app.js']
b = browserify(entries)
b.plugin('browserify-maybe-multi-require', {
  require: ['*', './non_package_modules/jquery-2.1.3.js:jquery']
  getFiles: () -> entries # このファイル一覧からrequireしているmodule一覧を取得し、
                          # プラグイン内部でb.requireしている
})
```

# ファイル構成

```
root
├── gulpscripts                        - gulp用スクリプト置き場
|   ├── ast-parser.coffee              - コードのパース処理を行う(get-requires-from-filesで使う)
|   ├── get-requires-from-files.coffee - ファイルからrequire文字列を取得する
|   ├── gulp-callback.coffee           - gulpのストリームの流れからcallbackを呼ぶ
|   └── to-relative-path.coffee        - 絶対パスを相対パスへ
├── bower.json          - Bowerパッケージ
├── package.json        - nodeパッケージ
├── non_package_modules - 野良module
|   └── jquery-2.1.3.js - (あえてパッケージ管理をしていない)
└── gulpsfile.coffee - gulpメイン
```

# Licence

MIT
