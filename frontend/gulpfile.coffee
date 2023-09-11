
gulp         = require("gulp")
coffee       = require("gulp-coffee")
stylus       = require("gulp-stylus")
watch        = require("gulp-watch")
livereload   = require("gulp-livereload")
include      = require("gulp-include")
prefix       = require("gulp-autoprefixer")
concat       = require("gulp-concat")
jade         = require("gulp-jade")
addsrc       = require("gulp-add-src")
uglify       = require("gulp-uglify")
csso         = require("gulp-csso")
changed      = require("gulp-changed")

path_dev     = "dev"
path_dist    = "dist"
path_distmin = "../backend/htdocs//dist/"


files =

	jade:
		watch:          path_dev + "/jade/**/*.jade"
		src:            path_dev + "/jade/pages/*.jade"
		destDist:       path_dist
		destDistMin:    path_distmin

	stylus:
		watch:          path_dev + "/stylus/**/*.styl"
		src:            path_dev + "/stylus/*.styl"
		destDist:       path_dist + "/css"
		destDistMin:    path_distmin + "/css"

	coffee:
		watch:          path_dev + "/coffee/**/**/*.coffee"
		src:            path_dev + "/coffee/app.coffee"
		destDist:       path_dist + "/js"
		destDistMin:    path_distmin + "/js"
		plugins:		[
							"bower_components/jquery/dist/jquery.min.js",
							"bower_components/hammerjs/hammer.min.js",
							"bower_components/nestable/jquery.nestable.js",
							"node_modules/swiper/swiper-bundle.min.js",
							"bower_components/jquery-zoom/jquery.zoom.js",

						]

gulp.task "default", ->

	livereload.listen()
	gulp.watch(path_dist + "/css/*.css").on "change", livereload.changed

	gulp.watch files.jade.watch,        [ "build:html" ]
	gulp.watch files.stylus.watch,      [ "build:css" ]
	gulp.watch files.coffee.watch,      [ "build:js" ]

	return


gulp.task 'build', [
	'build:html'
	'build:js'
	'build:css'
]

gulp.task "build:html", ->
	gulp.src(files.jade.src)
		.pipe(jade(pretty: true))
		.pipe(gulp.dest(files.jade.destDist))
	return

gulp.task "build:css", ->
	gulp.src(files.stylus.src)
		#.pipe(concat("main.styl"))
		.pipe(stylus({'include css': true}))
		.pipe(prefix())
		.pipe(csso())
		.pipe(gulp.dest(files.stylus.destDist))
		.pipe(gulp.dest(files.stylus.destDistMin))
	return

gulp.task "build:js", ->
	gulp.src(files.coffee.src)
		.pipe(include())
		.pipe(coffee(bare: true))
		.pipe(addsrc.prepend(files.coffee.plugins))
		.pipe(concat("main.js"))
		.pipe(uglify())
		.pipe(gulp.dest(files.coffee.destDist))
		.pipe(gulp.dest(files.coffee.destDistMin))
	return


