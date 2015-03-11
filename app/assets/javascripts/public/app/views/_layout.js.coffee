class App.Views.Layout extends View

  initialize: ->
    new App.Behaviors.Modals($el: @$el)
    new App.Behaviors.SmartScrollBar($el: @$el)
    new App.Behaviors.SectionsNav($el: @$el)
    new App.Behaviors.Animations($el: @$el)

