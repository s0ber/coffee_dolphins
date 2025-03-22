class App.Views.PopupTest extends Dolphin.View

  events:
    'click': 'showPopup'

  showPopup: ->
    @emit('popups:show', html: 'OLOLO', $button: @$el)
