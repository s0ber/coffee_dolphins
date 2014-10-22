@NotificationsModule =

  # TODO: this is now only working with views, add configure chain to base class (Frames)
  included: (klass) ->
    klass.addToConfigureChain('__initializeNotifications')

  extended: (klass) ->
    klass.emitter = new Noted.Emitter(Dolphin.broker, klass)
    klass.receiver = new Noted.Receiver(Dolphin.broker, klass)

  __initializeNotifications: ->
    @emitter = new Noted.Emitter(Dolphin.broker, @)
    @receiver = new Noted.Receiver(Dolphin.broker, @)

  emit: (message, body, options) ->
    @emitter.emit(message, body, options)

  listen: (message, callback, options) ->
    @receiver.listen(message, callback, options)

  unsubscribe: (message, callback, context) ->
    Dolphin.broker.unsubscribe(message, callback, @)

  showNotice: (message, hideAfterMs = 5000) ->
    @emit('flash_messages:notice', message, hideAfter: hideAfterMs)

  showAlert: (message, hideAfterMs = 5000) ->
    @emit('flash_messages:alert', message, hideAfter: hideAfterMs)
