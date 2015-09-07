var config = require('../config')
var gulp = require('gulp')

gulp.task('test-watch', function() {
  gulp.watch([config.paths.test, config.paths.js], ['test'])
})