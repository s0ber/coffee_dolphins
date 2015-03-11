class App.Behaviors.Sticky extends View

  initialize: ->
    @topPos = 0
    @$window = $(window)

    @$clonedEl = @$el.clone()
    @$clonedEl.hide().addClass('is-fixed js-fixed')
    @appendAsync($('body'), @$clonedEl)

    @$window.on('scroll', _.throttle(_.bind(@processScroll, @), 50))

  processScroll: ->
    isFixed = @$window.scrollTop() > @topPos
    @$clonedEl.toggle(isFixed)
    @$el.toggleClass('is-hidden', isFixed)

  # accessors

  $window: ->
    @_$window ?= $(window)
