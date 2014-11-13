class App.Behaviors.RemoteLinks extends Dolphin.View

  events:
    'ajax:before [href][data-remote="true"]': 'onBeforeLinkSubmit'
    'ajax:success [href][data-remote="true"]': 'onSuccessLinkSubmit'
    'ajax:error [href][data-remote="true"]': 'onFailedLinkSubmit'

  onBeforeLinkSubmit: (e) ->
    $button = $(e.currentTarget)
    return false if $button.hasClass('is-disabled')

    @utils.showButtonLoader($button)

  onSuccessLinkSubmit: (e, json) ->
    $button = $(e.currentTarget)
    @utils.hideButtonLoader($button)

  onFailedLinkSubmit: (e, response) ->
    $button = $(e.currentTarget)
    @utils.hideButtonLoader($button)

