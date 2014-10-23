Vtree.onNodeInit (node) ->
  viewNode = new ViewNodeDataWrapper(node).toJSON()

  try
    ViewClass =
      if node.isStandAlone
        window[viewNode.namespaceName].Views[viewNode.nodeName]
      else
        window[viewNode.namespaceName][viewNode.componentName].Views[viewNode.nodeName]
  catch e
    console.warn "Can find view class for '#{viewNode.viewName}'"
    return null

  try
    console.log "Initialize view '#{viewNode.viewName}'"
    node.setData('view', new ViewClass(viewNode))
  catch e
    console.error "Exception was raised while initializing view '#{viewNode.viewName}'"
    console.error e.message
    console.error printStackTrace(e: e).join('\n')

Vtree.onNodeUnload (node) ->
  view = node.getData 'view'
  return unless view?
  view.onUnload?()
  console.log "Unload view '#{view.options.viewName}'"

ViewNodeDataWrapper = class

  constructor: (@node) ->

  toJSON: ->
    node: @node
    el: @el()
    componentId: @componentId()
    namespaceName: @namespaceName()
    componentName: @componentName()
    nodeName: @nodeName()
    viewName: @viewName()

  el: ->
    @node.el

  componentId: ->
    @node.componentId || 0

  namespaceName: ->
    @node.namespaceName

  componentName: ->
    @node.componentName

  nodeName: ->
    @node.nodeName

  viewName: ->
    @_viewName ?=
      if @node.isStandAlone
        "#{@node.namespaceName}.Views.#{@node.nodeName}:#{@componentId()}"
      else
        "#{@node.namespaceName}.#{@node.componentName}.Views.#{@node.nodeName}:#{@componentId()}"

