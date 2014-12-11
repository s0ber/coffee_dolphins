class App.Views.Autoresize extends Dolphin.View

  initialize: ->
    @$el.find('textarea').autosize()

