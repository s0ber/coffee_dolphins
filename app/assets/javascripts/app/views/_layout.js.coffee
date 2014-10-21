FRAMES_BATCH_COUNT = 3

class App.Views.Layout extends App.View

  events:
    'click a@app-menu_item': 'processLinkClick'

  initialize: ->
    @historyWidget = Histo.addWidget(id: 'menu_navigation')
    @setInitialState()
    @historyWidget.onPopState @processPoppedState.bind(@)

  setInitialState: ->
    activeMenuItemId = @$menu()
      .find('.is-active')
      .data('menu-item-id')

    @historyWidget.replaceInitialState('active_menu_item_id': activeMenuItemId)

  processPoppedState: (state, path, dfd) ->
    activeMenuItemId = state['active_menu_item_id']
    $link = @$menu().find("[data-menu-item-id='#{activeMenuItemId}']")

    dfd.fail =>
      ijax.abortCurrentRequest()

    ijax.get(path).done (res) =>
      frames = []

      res
        .onLayoutReceive((html) =>
          @setLinkAsActive($link)
          @utils.scrollTop()
          @$pageWrapper().html(html)
        )
        .onFrameReceive(@processFrameReceive.bind(@, frames))
        .onResolve(=>
          @renderFrames(frames)
          dfd.resolve()
        )

  processLinkClick: (e) ->
    e.preventDefault()

    $link = $(e.currentTarget)
    return if $link.hasClass('is-active')

    activeMenuItemId = $link.data('menu-item-id')
    path = $link.attr('href')

    ijax.get(path).done (response) =>
      frames = []

      response
        .onLayoutReceive((html) =>
          @setLinkAsActive($link)
          @utils.scrollTop()
          @historyWidget.pushState(path, 'active_menu_item_id': activeMenuItemId)
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

  setLinkAsActive: ($link) ->
    $link
      .siblings()
        .removeClass('is-active')
        .end()
      .addClass('is-active')

  # getters

  $menu: ->
    @_$menu ?= @$('@app-menu')

  $pageWrapper: ->
    @_$pageWrapper ?= @$('@app-page_wrapper')
