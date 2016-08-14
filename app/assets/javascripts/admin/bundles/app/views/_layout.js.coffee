class App.Views.Layout extends Dolphin.View

  initialize: ->
    @applyBehavior 'RemoteLinks'
    @applyBehavior 'Modals'
    @applyBehavior 'Popups'
    @applyBehavior 'HistoryApiNavigation' if Modernizr.history

