Vtree.onNodeInit (node) ->
  viewName = "#{node.namespaceName}.Views.#{node.nodeName}"

  try
    ViewClass = window[node.namespaceName].Views[node.nodeName]
    throw new Error('Class not found') unless ViewClass?
  catch e
    console.warn "Can find view class for '#{viewName}'"
    return null

  console.log "Initialize view '#{viewName}'"

  node.setData('viewName', viewName)
  node.setData('view', new ViewClass(node))

Vtree.onNodeUnload (node) ->
  view = node.getData('view')
  viewName = node.getData('viewName')

  view.onUnload()
  console.log "Unload view '#{viewName}'"

$ ->
  Vtree.initNodes()
