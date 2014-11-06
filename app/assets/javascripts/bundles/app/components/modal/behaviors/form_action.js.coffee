class App.Modal.Behaviors.FormActions extends Dolphin.View

  events:
    'ajax:success form': 'forwardSubmitToButton'

  forwardSubmitToButton: (e, json) ->
    return if json.redirect or json.browser_redirect

    @emit 'modals:close_modal'
    @$modalSourceButton.trigger('modal_button:updated', json)
