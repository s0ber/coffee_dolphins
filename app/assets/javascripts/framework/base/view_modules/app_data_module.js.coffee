@AppDataModule =

  included: (klass) ->
    klass.addToConfigureChain '__extendWithComponentData'

  __extendWithComponentData: (options) ->
    return unless options.node?
    if componentData = options.node.componentIndexNode?.getData 'cache'
      _.extend(@, componentData)

  addComponentData: (data) ->
    return unless @node?.isComponentIndex

    unless componentData = @node.getData 'cache'
      @node.setData('cache', {})
      componentData = @node.getData 'cache'

    Object.merge(componentData, data)
    Object.merge(@, data)
