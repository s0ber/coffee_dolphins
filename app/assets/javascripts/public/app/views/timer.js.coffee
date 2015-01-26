class App.Views.Timer extends View

  TIME_LEFT_MIN = 60 * 60 * 1
  TIME_LEFT_AVERAGE = 60 * 60 * 2
  TIME_LEFT_MAX = 60 * 60 * 3

  els:
    hours: '.js-hours'
    minutes: '.js-minutes'
    seconds: '.js-seconds'

  initialize: ->
    @setTimerEndTime() unless @timerEndTime()?

    @updateTimer()
    setInterval(_.bind(@updateTimer, @), 1000)

  updateTimer: ->
    timeLeft = @timerEndTime() - @currentTime()
    @setTimerEndTime() if timeLeft <= 0

    hours = Math.floor(timeLeft / 3600)
    minutes = Math.floor((timeLeft % 3600) / 60)
    seconds = Math.floor((timeLeft % 3600) % 60)

    _.each [{$el: @$hours, val: hours},
            {$el: @$minutes, val: minutes},
            {$el: @$seconds, val: seconds}], (timerCell) ->

      {$el, val} = timerCell
      curValue = parseInt($el.text(), 10)

      if val isnt curValue
        $el.addClass('animate-zoom')
        setTimeout((-> $el.removeClass('animate-zoom')), 100)

      $el.text(val)

  timerEndTime: ->
    $.cookie("timer_end_time_#{@landingId()}")

  setTimerEndTime: ->
    timeLeft =
      if @forHomePage()
        @getRandomInt(TIME_LEFT_MIN, TIME_LEFT_MAX)
      else
        TIME_LEFT_AVERAGE

    $.cookie("timer_end_time_#{@landingId()}", @currentTime() + timeLeft, path: '/')

# private

  getRandomInt: (min, max) ->
     Math.floor(Math.random() * (max - min + 1)) + min

  currentTime: ->
    Math.round(+new Date() / 1000)

  landingId: ->
    @_landingId ?= @$el.data('landing-id')

  forHomePage: ->
    @_forHomePage ?= @$el.data('for-home-page')

