class App.Views.Timer extends View

  TIME_LEFT = 2 * 24 * 60 * 60 * 1000

  els:
    days: '.js-days'
    hours: '.js-hours'
    minutes: '.js-minutes'
    seconds: '.js-seconds'

  initialize: ->
    @updateTimer()
    setInterval(_.bind(@updateTimer, @), 1000)

  updateTimer: ->
    timeLeft = @timerEndTime() - @currentTime()

    days = Math.floor(timeLeft / 86400)
    hours = Math.floor(timeLeft / 3600) % 24
    minutes = Math.floor((timeLeft % 3600) / 60)
    seconds = Math.floor((timeLeft % 3600) % 60)

    hours = ('0' + hours) if hours < 10
    minutes = ('0' + minutes) if minutes < 10
    seconds = ('0' + seconds) if seconds < 10

    _.each [{$el: @$days, val: days},
            {$el: @$hours, val: hours},
            {$el: @$minutes, val: minutes},
            {$el: @$seconds, val: seconds}], (timerCell) ->

      {$el, val} = timerCell
      curValue = parseInt($el.text(), 10)

      if parseInt(val, 10) isnt curValue
        $el.addClass('animate-zoom')
        setTimeout((-> $el.removeClass('animate-zoom')), 100)

      $el.text(val)

# private

  timerEndTime: ->
    @_timerEndTime ?= do ->
      finishDate = new Date(new Date().getTime() + TIME_LEFT)
      finishDate = new Date("#{finishDate.getMonth() + 1}/#{finishDate.getDate()}/#{finishDate.getFullYear()} 5:00 AM")
      Math.round(+finishDate / 1000)

  currentTime: ->
    Math.round(+new Date() / 1000)

