class App.Views.Modal extends View

  initialize: ->
    @$window = $(window)

    @$modalsLayer = $('.js-modals-layer')
    @$modalsContainer = $('.js-modals-container')

    @locate()
    @$window.on('resize.modal:position', @locate.bind(@))

    @sub 'relocate_modal', =>
      @locate(true)

  unload: ->
    @$window.off('.modal:position')

  locate: (force) ->
    @$modalsLayer.scrollTop(0)

    winHeight = @$window.height()
    screenWidth = @$modalsContainer.width()

    # don't recalculate this when resizing in one axis
    if (winHeight isnt @lastWinHeight or force is true)
      modalHeight = @$modalsContainer.outerHeight()

      if modalHeight < winHeight
        marginTop = parseInt((winHeight - modalHeight) / 2, 10)
      else
        marginTop = 0

      @$modalsContainer.css('marginTop', marginTop + 'px')
      @lastWinHeight = winHeight

    if (screenWidth isnt @lastScreenWidth or force is true)
      @$el.css('margin-left', parseInt((screenWidth - @$el.width()) / 2, 10) + 'px')
      @lastScreenWidth = screenWidth

