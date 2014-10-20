gulp = require('gulp')
gutil = require('gulp-util')
karma = require('gulp-karma')

GemsAssetsData = require('gems-assets-data')
gemsAssets = new GemsAssetsData()

gulp.task 'resolve_gems_data', ->
  gemsAssets.resolve()

gulp.task 'karma:ci', ['resolve_gems_data'], ->
  gulp.src('')
    .pipe(karma(
      configFile: 'karma.conf.coffee'
      browsers: ['PhantomJS']
      gemsDirs: gemsAssets.dirs()
      reporters: ['junit', 'dots']
    ))

gulp.task 'karma:dev', ['resolve_gems_data'],  ->
  gulp.src('')
    .pipe(karma(
      configFile: 'karma.conf.coffee'
      reporters: ['dots']
      action: 'watch'
      gemsDirs: gemsAssets.dirs()
    ))
