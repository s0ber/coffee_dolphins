#= require_self
#= require_tree ./utils
#= require_tree ./views

@App = {}
App.Views = {}
App.Utils = {}

class App.View extends Backbone.View

  html: ($el, html) ->
    Vtree.DOM.html($el, html)

  after: ($el, $insertedEl) ->
    Vtree.DOM.after($el, $insertedEl)

  utils: App.Utils

  createNewRequest: (xhr) ->
    @abortCurrentRequest()
    @xhr = xhr

  abortCurrentRequest: ->
    @xhr.abort() if @xhr? and @xhr.state() isnt 'resolved'

