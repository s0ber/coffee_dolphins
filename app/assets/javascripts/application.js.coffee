#= require vendor
#= require_tree ./initializers
#= require_tree ./app

$ ->
  window.ijax = new Ijax()
  Vtree.initNodes()
