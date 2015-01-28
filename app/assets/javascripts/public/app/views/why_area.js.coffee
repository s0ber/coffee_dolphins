class App.Views.WhyArea extends View

  initialize: ->
    @__trackWhyButtonNavigation()

# private

  __trackWhyButtonNavigation: ->
    @$el.on 'click', ->
      gaWidget.trackEvent 'Навигация', 'Кнопка почему'
