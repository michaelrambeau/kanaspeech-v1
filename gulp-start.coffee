gulp = require('gulp')
concat = require('gulp-concat')
sass = require('gulp-sass')
coffee = require('gulp-coffee')
minifyCss = require('gulp-minify-css');
rename = require('gulp-rename');

paths =
	sass: [
		"./scss/**/*.scss"
		"./scss/**/*.sass"
	]
	coffee: [
		'./app/app.coffee'
		'./app/services/*.coffee'
		'./app/main-controller.coffee'
		'./app/*/*.coffee'
	]

gulp.task 'coffee', (done) ->
  gulp.src(paths.coffee)
    .pipe(coffee())
		.pipe(concat('app-concat.js'))
    .pipe(gulp.dest('./www/js/'))

gulp.task 'sass', (done) ->
  gulp.src './scss/ionic.app.scss'
    .pipe sass()
    .pipe gulp.dest('./www/css/')
    .pipe minifyCss(
      keepSpecialComments: 0
		)
    .pipe rename(
			extname: '.min.css'
		)
    .pipe gulp.dest('./www/css/')

gulp.task 'watch', () ->
	gulp.watch './app/**/*.coffee', ['coffee']
	gulp.watch paths.sass, ['sass']
