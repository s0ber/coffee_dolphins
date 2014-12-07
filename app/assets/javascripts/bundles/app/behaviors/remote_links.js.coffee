class App.Behaviors.RemoteLinks extends Dolphin.View

  events:
    'ajax:before [href][data-remote="true"]': 'onBeforeLinkSubmit'
    'ajax:success [href][data-remote="true"]': 'onSuccessLinkSubmit'
    'ajax:error [href][data-remote="true"]': 'onFailedLinkSubmit'

  onBeforeLinkSubmit: (e) ->
    $link = $(e.currentTarget)
    return false if $link.hasClass('is-disabled')
    @showLoader($link)

  onSuccessLinkSubmit: (e, json) ->
    $link = $(e.currentTarget)
    @hideLoader($link)
    @showNotice(json.notice) if json.notice

  onFailedLinkSubmit: (e, response) ->
    $link = $(e.currentTarget)
    @hideLoader($link)

# private

  showLoader: ($link) ->
    @utils.disableLink($link)
    @utils.showButtonLoader($link)

  hideLoader: ($link) ->
    @utils.enableLink($link)
    @utils.hideButtonLoader($link)
