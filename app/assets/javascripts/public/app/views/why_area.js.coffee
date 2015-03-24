class App.Views.WhyArea extends View

  initialize: ->
    @__trackWhyButtonNavigation()

# private

  __trackWhyButtonNavigation: ->
    @$el.on 'click', ->
      # @trackEvent 'Навигация', 'Кнопка почему'
