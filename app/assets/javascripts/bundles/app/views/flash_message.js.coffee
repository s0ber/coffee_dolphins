class App.Views.FlashMessage extends Dolphin.View

  events:
    'click @flash_message-close': 'close'

  initialize: ->
    @close.bind(@).delay(5000)

  close: (e) ->
    @$el.fadeOut('fast', => @$el.remove())
