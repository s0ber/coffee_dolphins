class App.Views.Layout extends Dolphin.View

  initialize: ->
    @applyBehavior 'RemoteLinks'
    @applyBehavior 'HistoryApiNavigation'

