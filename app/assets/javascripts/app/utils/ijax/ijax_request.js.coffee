class @IjaxRequest

  constructor: (path) ->
    @id = @getGuid()
    @path = @_updatePathParams(path, format: 'al', i_req_id: @id, full_page: true)

    @isResolved = false
    @isRejected = false

    @iframe = @createIframeRequest()
    @iframe.onload = @updateIframeStatus.bind(@)

  done: (@onDoneCallback) ->
    @

  fail: (@onFailCallback) ->
    @

  onAbort: (@onAbortCallback) ->
    @

  onCancel: (@onCancelCallback) ->
    @

  resolve: ->
    @isResolved = true
    @onDoneCallback(@response)

  reject: ->
    return if @isRejected
    @isRejected = true
    @onFailCallback?(args...)
    @removeIframe()

  registerResponse: ->
    @response = new IjaxResponse()

  updateIframeStatus: ->
    @removeIframe()
    @showError() unless @isResolved

  showError: ->
    console.log 'PIZDEC'

  createIframeRequest: ->
    src = @path or 'javascript:false'

    tmpElem = document.createElement('div')
    tmpElem.innerHTML = "<iframe name=\"#{@id}\" id=\"#{@id}\" src=\"#{src}\">"

    iframe = tmpElem.firstChild
    iframe.style.display = 'none'

    document.body.appendChild(iframe)
    iframe

  removeIframe: ->
    @iframe.parentNode.removeChild(@iframe)

  getGuid: ->
    @_s4() + @_s4() + '-' + @_s4() + '-' + @_s4() + '-' + @_s4() + '-' + @_s4() + @_s4() + @_s4()

  _updatePathParams: (path, params) ->
    path

    for own key, value of params
      re = new RegExp("([?|&])#{key}=.*?(&|$)", 'i')
      separator = if path.indexOf('?') isnt -1 then '&' else '?'

      path =
        if re.test(path)
          path.replace(re, "$1#{key}=#{value}$2")
        else
          path + separator + key + '=' + value

    path

  _s4: ->
    Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1)

