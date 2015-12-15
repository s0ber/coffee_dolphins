class App.Views.BetPage extends Dolphin.View

  events:
    'ajax:success form': 'redrawPage'
    'modal_button:update [data-modal]': 'redrawPage'

  initialize: ->
    @applyBehavior('Dynamic')

  redrawPage: ->
    @behaviors.Dynamic.redraw()
