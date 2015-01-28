class Widgets.GoogleAnalytics

  constructor: (@applicationId) ->
    return unless @enabled()

    @setup()
    window['ga']?('create', @applicationId, 'auto')

  enabled: ->
    @applicationId? && @applicationId.replace(/^\s+|\s+$/gm,'').length > 0

  setup: ->
    `(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');`

  trackPageview: ->
    window['ga']?('send', 'pageview')

  trackEvent: (args...) ->
    window['ga']?('send', 'event', args...)

