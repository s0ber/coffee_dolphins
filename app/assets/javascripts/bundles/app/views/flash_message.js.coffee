class App.Views.FlashMessage extends Dolphin.View

  HIDE_AFTER = 5000

  events:
    'click @flash_message-close': 'close'

  initialize: ->
    @close.bind(@).delay(HIDE_AFTER)

  close: (e) ->
    @$el.fadeOut('fast', => @$el.remove())

