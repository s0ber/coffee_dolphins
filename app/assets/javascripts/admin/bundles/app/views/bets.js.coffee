class App.Views.Bets extends Dolphin.View

  els:
    betsContainer: '@bets-container'
    bets: '@bets-bet'

  events:
    'click @bets-add': 'addBet'

  addBet: ->
    $bet = $(@betTemplate().html)
    $bet.find('input, textarea').each (i, field) =>
      $field = $(field)
      name = $(field).attr('name')
      $(field)
        .removeAttr('id')
        .attr(name: name.replace('0', @betsCounter()))

    @append(@$betsContainer(), $bet)
    $bet.autofocus()
    @incrementBetsCounter()

# getter

  betTemplate: ->
    @$el.data('bet-template')

  betsCounter: ->
    @_betsCounter ?= @$bets().length

  incrementBetsCounter: ->
    @_betsCounter++
