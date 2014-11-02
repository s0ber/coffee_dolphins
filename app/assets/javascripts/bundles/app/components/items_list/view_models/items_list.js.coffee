class ItemModel extends Dolphin.Model

class ItemsCollection extends Dolphin.Collection
  model: ItemModel

class App.ItemsList.ViewModels.ItemsList extends Dolphin.ViewModel

  initialize: ->
    @setCollection(new ItemsCollection())

  addItem: (item) ->
    @addToCollection(new ItemModel(item))

  removeItemById: (id) ->
    itemModel = @collection.get(id)
    @removeFromCollection(itemModel)

  addFetchedItemData: (data...) ->
    @trigger('item_data_fetched', data...)

  setFormAsOpened: ->
    @trigger('form_set_opened')

  setFormAsClosed: ->
    @trigger('form_set_closed')

