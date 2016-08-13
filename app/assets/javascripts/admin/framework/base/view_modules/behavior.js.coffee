@BehaviorModule =

  included: (klass) ->
    klass.addToRemoveChain('__unloadBehavior')

  applyBehavior: (name, options = {}) ->
    options = _.extend({}, @options, options, isBehavior: true, view: @)
    console.log "Apply behavior '#{name}' to view '#{options.viewName}'"

    @behaviors ?= {}
    throw new Error('Behavior already applied') if @behaviors[name]?

    if options.componentName?
      # finding behavior in a component
      Class = window[options.namespaceName][options.componentName].Behaviors?[name]

    # if no behavior found, finding it in a main namespace
    Class ?= window[options.namespaceName].Behaviors?[name]

    @behaviors[name] = new Class(options)

    @behaviors[name]

  __unloadBehavior: ->
    return unless @behaviors

    for own name, behavior of @behaviors
      console.log "Unload behavior '#{name}' from view '#{@options.viewName}'"
      behavior.onUnload()

    @behaviors = {}

