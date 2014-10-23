class ItemModel extends Dolphin.Model

class ItemsCollection extends Dolphin.Collection
  model: ItemModel

class App.ItemsList.ViewModels.ItemsList extends Dolphin.ViewModel

  initialize: ->
    @collection = new ItemsCollection()

    @listenTo @collection, 'change', =>
      @setFormAsOpened() if @isEmpty()

  addItem: (item) ->
    itemModel = new ItemModel(item)

    @collection.add(itemModel)
    @trigger('item_added', itemModel.toJSON())

  removeItemById: (id) ->
    itemModel = @collection.get(id)

    @item.remove(itemModel)
    @trigger('item_removed', itemModel.toJSON())

  addFetchedItemData: (data...) ->
    @trigger('item_data_fetched', data...)

  setFormAsOpened: ->
    @trigger('form_set_opened')

  setFormAsClosed: ->
    @trigger('form_set_closed')

  isEmpty: ->
    @collection.size() is 0

  size: ->
    @collection.size()

  toJSON: ->
    @collection.toJSON()

