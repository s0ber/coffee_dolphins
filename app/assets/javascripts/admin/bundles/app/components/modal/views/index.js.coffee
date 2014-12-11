class App.Modal.Views.Index extends Dolphin.View

  events: {}

  initialize: ->
    @addComponentData($modalSourceButton: @options.$modalSourceButton)
    @applyBehavior 'FormActions'

    @$window = $(window)
    @$modalsContainer = $('@modals-container')

    @locate()
    @$window.on('resize.modal:position', @locate.bind(@))

    @$el.autofocus()

  unload: ->
    @$window.off('.modal:position')

  locate: (force) ->
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

