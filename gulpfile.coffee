gulp        = require 'gulp'
$           = require('gulp-load-plugins')()
runSequence = require 'run-sequence'
browserify  = require 'browserify'
watchify    = require 'watchify'
source      = require 'vinyl-source-stream'

del        = require 'del'
globule    = require 'globule'
_          = require 'lodash'

maybeMultiRequire = require 'browserify-maybe-multi-require'
getRequiresFromFiles = require './gulpscripts/get-requires-from-files'
callback        = require './gulpscripts/gulp-callback'

# ---------------
# build tasks ---

gulp.task 'build:lib', ['build:coffee', 'build:html']

# coffee build task
gulp.task 'build:coffee', () ->
  gulp.src('src/**/*.coffee')
    .pipe($.coffee())
    .pipe(gulp.dest 'lib')

# html build task
gulp.task 'build:html', () ->
  gulp.src('src/**/*.html')
    .pipe(gulp.dest 'public')

# browserify task
# common-bundle.js側に含めるmodule群
common_bundle_requires = [
  '*'
  './non_package_modules/jquery-2.1.3.js:jquery'
]

prev_requires = []
# NOTE : キャッシュも兼ねる
args_common = _.merge(_.cloneDeep(watchify.args), {
  cache: {}
  packageCache: {}
  fullPaths: false
  
  debug: false
})
browserifyCommonCore = () ->
  entries = globule.find(['./lib/**/*.js'])
  requires = _.sortBy(getRequiresFromFiles(entries))
  # 必要時だけ再bundle
  if (!_.isEqual(requires, prev_requires))
    prev_requires = requires

    b = browserify(args_common)
    b.plugin(maybeMultiRequire, {
      # underscore以外を含める
      require: common_bundle_requires
      getFiles: () -> entries
      external: ['underscore']
    })
    w = watchify(b) # 差分ビルドのみに使う
    b
      .bundle()
      .pipe(source 'common-bundle.js')
      .pipe(gulp.dest 'public')
      .pipe($.duration 'browserify common-bundle.js bundle time')
      .pipe(callback(() ->
        w.close()
      ))
      
browserifyCore = (wathing) ->
  entries = globule.find(['./lib/**/*.js'])
  # NOTE : キャッシュも兼ねる
  args = _.merge(_.cloneDeep(watchify.args), {
    cache: {}
    packageCache: {}
    fullPaths: false

    debug: false
  })
  b = undefined
  bundle = () ->
    b
      .bundle()
      .pipe(source 'bundle.js')
      .pipe(gulp.dest 'public')
      .pipe($.duration 'browserify bundle.js bundle time')
      .pipe(callback(() ->
        # no-op
      ))
  setup = () ->
    b = browserify(args)
    for x in entries
      b.add(x)
      b.require(x)
    b.plugin(maybeMultiRequire, {
      # underscoreだけを含める
      require: ['underscore']
      getFiles: () -> entries
      external: common_bundle_requires
    })
    if (wathing)
      w = watchify(b, {delay: 100})
      w.on('update', () ->
        setup()
        bundle()
      )
  setup()
  bundle()
  
gulp.task 'browserify-common', () -> browserifyCommonCore()
  
gulp.task 'browserify', () -> browserifyCore(false)
gulp.task 'watchify', () -> browserifyCore(true)

# ----------------
# public tasks ---

gulp.task 'build', (cb) -> runSequence('clean', 'build:lib', 'browserify-common', 'browserify', cb)

gulp.task 'pre-watch', (cb) -> runSequence('clean', 'build:lib', 'browserify-common', 'watchify', cb)
gulp.task 'watch', ['pre-watch'], () ->
  changedWatch = (watch_files, cb) ->
    watcher = gulp.watch(watch_files)
    watcher.on('change', (e) ->
      if (e.type is 'changed')
        cb()
    )
  changedWatch('src/**/*.coffee', () ->
    runSequence('build:coffee', 'browserify-common') # NOTE : 監視ファイルが無くwatchify出来ないので、明示的にbrowserify-common
  )


gulp.task 'clean', (cb) -> del(['public', 'lib'], cb)

gulp.task 'default', () -> console.log("usage) gulp (build | watch | clean)")
