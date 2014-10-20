class Ijax

  constructor: ->
    @requests = {}

  get: (path) ->
    @abortCurrentRequest()

    @curRequest = request = new IjaxRequest(path)
    @requests[request.id] = request
    request

  abortCurrentRequest: ->
    return unless @curRequest?
    hasUnresolvedRequest = not @curRequest.isResolved
    hasUnresolvedResponse = not @curRequest.response?.isResolved

    if (hasUnresolvedRequest or hasUnresolvedResponse) and not @curRequest.isRejected
      @curRequest.reject()
      @removeRequest(@curRequest)

  registerResponse: (requestId) ->
    @curRequest = @requests[requestId]

    @curRequest.registerResponse()
    @curRequest.resolve()

  pushLayout: (html) ->
    @curRequest.response.addLayout(html)

  pushFrame: (frameId, frameHtml) ->
    @curRequest.response.addFrame(frameId, frameHtml)

  resolveResponse: ->
    @curRequest.response.resolve()
    @removeRequest(@curRequest)

  removeRequest: (request) ->
    delete @requests[request.id]

window.ijax = new Ijax()
