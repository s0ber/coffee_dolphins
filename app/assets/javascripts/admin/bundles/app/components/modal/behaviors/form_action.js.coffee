class App.Modal.Behaviors.FormActions extends Dolphin.View

  events:
    'ajax:success form': 'forwardSubmitToButton'
    'ajax:success [href][data-remote="true"]': 'onSuccessLinkSubmit'

  forwardSubmitToButton: (e, json) ->
    return if json.browser_redirect

    @emit 'modals:close_modal'
    @$modalSourceButton.trigger('modal_button:update', json)

  onSuccessLinkSubmit: (e, json) ->
    return if json.browser_redirect

    @emit 'modals:close_modal'
    @$modalSourceButton.trigger('modal_button:update', json)
