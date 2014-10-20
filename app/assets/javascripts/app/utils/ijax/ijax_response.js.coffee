class @IjaxResponse

  FRAMES_BATCH_COUNT = 3

  constructor: ->
    @isResolved = false

  addLayout: (layoutHtml) ->
    @onLayoutReceiveCallback?(layoutHtml)

  addFrame: (frameId, frameHtml) ->
    @onFrameReceiveCallback?(frameId, frameHtml)

  resolve: ->
    @isResolved = true
    @onResolveCallback?()

  onLayoutReceive: (@onLayoutReceiveCallback) ->
    @

  onFrameReceive: (@onFrameReceiveCallback) ->
    @

  onResolve: (@onResolveCallback) ->
    @

