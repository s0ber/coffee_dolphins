class App.ItemsList.Views.Item extends Dolphin.View

  initialize: ->
    @itemsList.addItem
      id: @$el.data('item-id')

