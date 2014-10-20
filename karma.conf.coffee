gulpKarmaOptions = JSON.parse(process.argv[2])

gemsDirs = gulpKarmaOptions.gemsDirs
sprocketsDirs = [
  'vendor/assets/components'
  'vendor/assets/javascripts'
  'lib/assets/javascripts'
  'app/assets/javascripts'
  'spec/javascripts'
]
manifestsPaths = gemsDirs.concat(sprocketsDirs)

sprocketsBundles = [
  'index.js.coffee'
]

console.log 'SPROCKETS MANIFESTS PATHS:'
console.log manifestsPaths

module.exports = (config) ->
  config.set
    preprocessors:
      '**/*.coffee': ['coffee'],
      '**/*.ejs': ['html2js']
    basePath: ''
    frameworks: ['sprockets', 'mocha', 'sinon-chai', 'chai-jquery']
    exclude: []
    reporters: ['progress']
    port: 9876
    colors: true
    autoWatch: true
    browsers: ['PhantomJS']
    captureTimeout: 60000
    singleRun: false

    coffeePreprocessor:
      options: {bare: false}

    junitReporter:
      outputFile: 'test_results/karma.xml'
      suite: ''

    sprocketsPath: manifestsPaths
    sprocketsBundles: sprocketsBundles
