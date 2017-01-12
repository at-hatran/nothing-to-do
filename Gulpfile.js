var gulp       = require('gulp');
var sourcemaps = require('gulp-sourcemaps');
var concat     = require("gulp-concat");
var sass       = require("gulp-sass");
var coffee     = require("gulp-coffee");
var del        = require("del");

gulp.task('styles', function() {
    gulp.src('./app/assets/stylesheets/**/*.scss')
        .pipe(sourcemaps.init())
        .pipe(sass().on('error', sass.logError))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('./app/assets/stylesheets/'));
});

gulp.task('concat-coffee', function() {
    gulp.src(['./app/assets/javascripts/railsbackbone.coffee',
              './app/assets/javascripts/models/**/*.coffee',
              './app/assets/javascripts/collections/**/*.coffee',
              './app/assets/javascripts/views/**/*.coffee',
              './app/assets/javascripts/routers/**/*.coffee'])
        .pipe(sourcemaps.init())
        .pipe(concat('app.coffee'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('./tmp/assets/javascripts/'));
});

gulp.task('compile-coffee', ['concat-coffee'], function() {
    gulp.src('./tmp/assets/javascripts/app.coffee')
        .pipe(coffee())
        .pipe(gulp.dest('./tmp/assets/javascripts/'));
});

gulp.task('clean', function(done) {
    del(['./tmp/assets/javascripts/*',
         './tmp/assets/stylesheets/*',
         './app/assets/javascripts/application.js'], done);
})

gulp.task('concat-js', ['compile-coffee'], function() {
    gulp.src(['./node_modules/underscore/underscore-min.js',
              './node_modules/jquery/dist/jquery.min.js',
              './node_modules/backbone/backbone-min.js',
              './tmp/assets/javascripts/app.js'])
        .pipe(concat('application.js'))
        .pipe(gulp.dest('./app/assets/javascripts/'));
});

// Watch task
gulp.task('run', ['clean', 'concat-js'], function() {
    gulp.watch('app/assets/stylesheets/**/*.scss', ['styles']);
    gulp.watch('app/assets/javascripts/**/*.coffee', ['concat-js']);
});
