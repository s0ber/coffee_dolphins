class App.ItemsList.Views.Item extends Dolphin.View

  events:
    'ajax:success @items_list-remove_item': 'removeItem'

  initialize: ->
    @itemsList.addItem id: @id()

  removeItem: ->
    @itemsList.removeItemById(@id())
    @$el.fadeOut(=> @$el.remove())

  id: ->
    @$el.data('item-id')

