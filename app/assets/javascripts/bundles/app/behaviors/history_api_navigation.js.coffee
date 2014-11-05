FRAMES_BATCH_COUNT = 3

class App.Behaviors.HistoryApiNavigation extends Dolphin.View

  els:
    menu: '@app-menu'
    menuItems: '@app-menu_item'
    pageWrapper: '@app-page_wrapper'

  events:
    'click a': 'processLinkClick'

  initialize: ->
    @historyWidget = Histo.addWidget(id: 'menu_navigation')

    @setInitialState()
    @historyWidget.onPopState @processPoppedState.bind(@)

  setInitialState: ->
    $activeLink = @$menu().find('.is-active')

    @historyWidget.replaceInitialState('page_path': $activeLink.attr('href'))

  processPoppedState: (state, path, dfd) ->
    $menuLink = @$menuItems().filter("[href='#{state['page_path']}']")

    dfd.fail => ijax.abortCurrentRequest()

    ijax.get(path).done (res) =>
      frames = []

      res
        .onLayoutReceive((html) =>
          @setLinkAsActive($menuLink)
          @utils.scrollTop()
          @$pageWrapper().html(html)
        )
        .onFrameReceive(@processFrameReceive.bind(@, frames))
        .onResolve(=>
          @renderFrames(frames)
          dfd.resolve()
        )

  processLinkClick: (e) ->
    return if @isClickedInNewTab(e)

    e.preventDefault()
    $link = $(e.currentTarget)
    $menuLink = @$menuItems().filter("[href='#{$link.attr('href')}']")
    return if $link.is('@app-menu_item.is-active') or not @isNavigationLink($link)

    path = $link.attr('href')

    ijax.get(path).done (response) =>
      frames = []

      response
        .onLayoutReceive((html) =>
          @setLinkAsActive($menuLink)
          @utils.scrollTop()
          @historyWidget.pushState(path, 'page_path': path)
          @$pageWrapper().html(html)
        )
        .onFrameReceive(@processFrameReceive.bind(@, frames))
        .onResolve(=>
          @renderFrames(frames)
        )

  processFrameReceive: (frames, frameId, frameHtml) ->
    frames.push
      id: frameId
      html: frameHtml

    # render by N frames
    @renderFrames(frames) if frames.length is FRAMES_BATCH_COUNT

  renderFrames: (frames) ->
    for frame in frames
      $appendNode = $ document.getElementById("append_#{frame.id}")
      @after($appendNode, frame.html)
      $appendNode.remove()

    frames.length = 0

  # private
  isClickedInNewTab: (e) ->
    e.which is 2 or e.metaKey or e.ctrlKey

  setLinkAsActive: ($link) ->
    unless $link.exists()
      @$menuItems().removeClass('is-active')
      return

    $link
      .siblings()
        .removeClass('is-active')
        .end()
      .addClass('is-active')

  isNavigationLink: ($link) ->
    isRemoteLink = $link.is('[data-remote]')
    isLocalLink = $link.attr('href')[0] is '/'

    isLocalLink and not isRemoteLink
