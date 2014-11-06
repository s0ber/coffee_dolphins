class PageFrames

  FRAMES_BATCH_COUNT = 7

  constructor: (@view) ->
    @frames = []

  addFrame: (id, html, path = null) ->
    @frames.push {id, html, path}
    @render() if @frames.length is FRAMES_BATCH_COUNT # render by N frames

  render: ->
    for frame in @frames
      if frame.id is 'layout'
        @_renderLayoutFrame(frame)
      else
        @_renderPartialFrame(frame)

    @frames.length = 0

  _renderLayoutFrame: (frame) ->
    @view.utils.scrollTop()
    if frame.path
      @view.historyWidget.pushState(frame.path, 'page_path': frame.path)
    @view.$pageWrapper().html(frame.html)

  _renderPartialFrame: (frame) ->
    $appendNode = $ document.getElementById("append_#{frame.id}")
    @view.after($appendNode, frame.html)
    $appendNode.remove()

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
    $menuLink = @$menuItemForPath(state['page_path'])

    dfd.fail => ijax.abortCurrentRequest()

    ijax.get(path).done (res) =>
      frames = new PageFrames(@)

      res
        .onLayoutReceive((html) =>
          @setLinkAsActive($menuLink)
          frames.addFrame('layout', html)
        )
        .onFrameReceive((id, html) -> frames.addFrame(id, html))
        .onResolve(=>
          frames.render()
          dfd.resolve()
        )

  processLinkClick: (e) ->
    return if @isClickedInNewTab(e)

    $link = $(e.currentTarget)
    return if not @isNavigationLink($link)

    e.preventDefault()

    $menuLink = @$menuItemForPath($link.attr('href'))
    path = $link.attr('href')
    shouldPushPath = "#{location.origin}#{path}" isnt location.href

    ijax.get(path).done (response) =>
      frames = new PageFrames(@)

      response
        .onLayoutReceive((html) =>
          @setLinkAsActive($menuLink)
          if shouldPushPath
            frames.addFrame('layout', html, path)
          else
            frames.addFrame('layout', html)
        )
        .onFrameReceive((id, html) -> frames.addFrame(id, html))
        .onResolve(=>
          frames.render()
        )

  # private

  isClickedInNewTab: (e) ->
    e.which is 2 or e.metaKey or e.ctrlKey

  $menuItemForPath: (path) ->
    @$menuItems().filter (i, menuItem) =>
      path.search($(menuItem).attr('href')) isnt -1

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
    isLogoutLink = $link.attr('href') is '/logout'

    isLocalLink and not isRemoteLink and not isLogoutLink
