@AjaxRequestsModule =

  createNewRequest: (xhr) ->
    @abortCurrentRequest()
    @xhr = xhr

  abortCurrentRequest: ->
    @xhr.abort() if @xhr? and @xhr.state() isnt 'resolved'
