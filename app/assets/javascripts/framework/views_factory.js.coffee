Vtree.onNodeInit (node) ->
  viewName = "#{node.namespaceName}.Views.#{node.nodeName}"
  viewConstructor = window[node.namespaceName]?.Views?[node.nodeName]

  unless viewConstructor
    console.warn "Error finding constructor for view '#{viewName}'"
    return

  try
    console.log "Initializing view '#{viewName}'"
    view = new viewConstructor(el: node.el, node: node)
    node.setData('view', view)
    node.setData('viewName', viewName)
  catch e
    console.error "Error occured while initializing view '#{viewName}'"
    console.error e.message

Vtree.onNodeUnload (node) ->
  view = node.getData 'view'
  return unless view?

  view.onUnload()

  viewName = node.getData 'viewName'
  console.log "Unloading view '#{viewName}'"

