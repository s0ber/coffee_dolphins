@NotificationsModule =

  # TODO: this is now only working with views, add configure chain to base class (Frames)
  included: (klass) ->
    klass.addToConfigureChain('__initializeNotifications')

  __initializeNotifications: ->
    @emitter = new Noted.Emitter(Dolphin.broker, @)
    @receiver = new Noted.Receiver(Dolphin.broker, @)

  emit: (message, body, options) ->
    @emitter.emit(message, body, options)

  listen: (message, callback, options) ->
    @receiver.listen(message, callback, options)

  unsubscribe: (message, callback) ->
    Dolphin.broker.unsubscribe(message, callback, @)

  showNotice: (message) ->
    @emit('flash_message:notice', message)

  showWarning: (message) ->
    @emit('flash_message:warning', message)

  showAlert: (message) ->
    @emit('flash_message:alert', message)

