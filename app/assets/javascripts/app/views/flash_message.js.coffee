class App.Views.FlashMessage extends App.View

  events:
    'click .js-flash_message-close': 'close'

  initialize: ->
    @close.bind(@).delay(5000)

  close: (e) ->
    @$el.fadeOut('fast', => @$el.remove())

