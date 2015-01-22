class App.Views.Timer extends View

  TIME_LEFT = 60 * 60 * 2

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
    $.cookie('timer_start_time')

  setTimerEndTime: ->
    $.cookie('timer_start_time', @currentTime() + TIME_LEFT)

# private
#
  currentTime: ->
    Math.round(+new Date() / 1000)

