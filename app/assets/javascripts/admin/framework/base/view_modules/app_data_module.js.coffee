@AppDataModule =

  included: (klass) ->
    klass.addToConfigureChain '__extendWithComponentData'

  __extendWithComponentData: (options) ->
    componentData =
      if options.isBehavior
        if options.view.node.isComponentIndex
          options.view.node?.getData 'cache'
        else
          options.view.node?.componentIndexNode?.getData 'cache'
      else
        options.node?.componentIndexNode?.getData 'cache'

    _.extend(@, componentData) if componentData?

  addComponentData: (data) ->
    return unless @node?.isComponentIndex

    unless componentData = @node.getData 'cache'
      @node.setData('cache', {})
      componentData = @node.getData 'cache'

    Object.merge(componentData, data)
    Object.merge(@, data)
