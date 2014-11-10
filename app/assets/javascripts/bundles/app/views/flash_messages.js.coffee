class App.Views.FlashMessages extends Dolphin.View

  events:
    'click @flash_message-close': 'close'

  initialize: ->
    @listen('flash_message:notice', @showNotice)
    @listen('flash_message:warning', @showWarning)
    @listen('flash_message:alert', @showAlert)

  showNotice: (m) ->
    message = m.body
    @_showMessage(message, 'notice')

  showWarning: (m) ->
    message = m.body
    @_showMessage(message, 'warning')

  showAlert: (m) ->
    message = m.body
    @_showMessage(message, 'alert')

# private

  _showMessage: (message, type) ->
    $message = @$renderTemplate('flash_message', {message, type})
    @append(@$el, $message)
