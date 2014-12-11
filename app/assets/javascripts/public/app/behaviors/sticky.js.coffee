class App.Behaviors.Sticky extends View

  initialize: ->
    @topPos = 0
    @$window = $(window)

    @$clonedEl = @$el.clone()
    @$clonedEl.hide().addClass('is-fixed js-fixed')
    @appendAsync($('body'), @$clonedEl)

    @$window.on('scroll', _.bind(@processScroll, @))

  processScroll: ->
    isFixed = @$window.scrollTop() > @topPos
    @$clonedEl.toggle(isFixed)
    @$el.toggleClass('is-hidden', isFixed)

  # accessors

  $window: ->
    @_$window ?= $(window)
