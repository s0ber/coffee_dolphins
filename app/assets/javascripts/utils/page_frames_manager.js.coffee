class Utils.PageFramesManager

  FRAMES_BATCH_COUNT = 7

  constructor: (options) ->
    {@view, @$pageContainer, @pagePath, @stateScrollTop} = options
    @frames = []

  addFrame: (id, html) ->
    @frames.push {id, html}
    @render() if @frames.length is FRAMES_BATCH_COUNT # render by N frames

  render: (lastRender = false) ->
    @_setBodyAsLoading()

    for frame in @frames
      if frame.id is 'layout'
        @_renderLayoutFrame(frame)
      else
        @_renderPartialFrame(frame)

    @frames.length = 0

    @_setBodyAsNotLoading() if lastRender
    @_scrollToStateTopPos() if @stateScrollTop

  $body: ->
    @_$body ?= $('body')

  _setBodyAsLoading: ->
    @$body().addClass('is-loading')

  _setBodyAsNotLoading: ->
    @$body().removeClass('is-loading')

  _renderLayoutFrame: (frame) ->
    @view.utils.scrollTop()

    # if path was provided to constructor, we are pushing new state
    if @pagePath
      @view.historyWidget.pushState(@pagePath, 'page_path': @pagePath, 'scroll_top_pos': 0)

    @view.html(@$pageContainer, frame.html)

  _renderPartialFrame: (frame) ->
    $appendNode = $ document.getElementById("append_#{frame.id}")
    @view.after($appendNode, frame.html)
    $appendNode.remove()

  _scrollToStateTopPos: ->
    return if @_isScrolled

    docHeight = $(document).height()
    screenHeight = $(window).height()

    pageScrollTop = $(document).scrollTop()

    if docHeight >= @stateScrollTop + screenHeight - 200
      (=>
        @view.utils.scrollTop(@stateScrollTop)
        if pageScrollTop < @stateScrollTop - 150
          @_scrollToStateTopPos()
        else
          @_isScrolled = true
      ).delay(50)
