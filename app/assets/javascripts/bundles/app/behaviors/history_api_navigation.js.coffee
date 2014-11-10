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

    @listen('page:load', (m) => @loadPage(m.body))
    @listen('page:reload', @reloadCurrentPage)

  setInitialState: ->
    $activeLink = @$menu().find('.is-active')

    @historyWidget.replaceInitialState('page_path': $activeLink.attr('href'))

  processPoppedState: (state, path, dfd) ->
    $menuLink = @$menuItemForPath(state['page_path'])

    dfd.fail => ijax.abortCurrentRequest()

    ijax.get(path).done (response) =>
      frames = new Utils.PageFramesManager
        view: @
        $pageContainer: @$pageWrapper()

      response
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
    @loadPage($link.attr('href'))

  loadPage: (path) ->
    $menuLink = @$menuItemForPath(path)
    shouldPushPath = "#{location.origin}#{path}" isnt location.href

    ijax.get(path).done (response) =>
      frames = new Utils.PageFramesManager
        view: @
        $pageContainer: @$pageWrapper()
        pagePath: (path if shouldPushPath)

      response
        .onLayoutReceive((html) =>
          @setLinkAsActive($menuLink)
          frames.addFrame('layout', html)
        )
        .onFrameReceive((id, html) -> frames.addFrame(id, html))
        .onResolve(=>
          frames.render()
        )

  reloadCurrentPage: ->
    @loadPage(location.pathname + location.search)

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
