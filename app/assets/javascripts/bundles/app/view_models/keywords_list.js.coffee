class Keyword extends Dolphin.Model
  defaults:
    search_count: 0

class Keywords extends Dolphin.Collection
  model: Keyword

class App.ViewModels.KeywordsList extends Dolphin.ViewModel

  initialize: ->
    @collection = new Keywords()
    @listenTo(@collection, 'change', => @trigger('change', @getItems()))
    @maxVirtualIndex = 0

  reset: (items) ->
    @collection.reset []

    for item in items
      @maxVirtualIndex++
      itemModel = new Keyword(item)
      @_addVirtualIndex(itemModel)
      @collection.add(itemModel)

    @trigger('items_reset', @collection.toJSON())

  add: (item) ->
    @maxVirtualIndex++
    itemModel = new Keyword(item)
    @_addVirtualIndex(itemModel)
    @collection.add(itemModel)
    @trigger('item_added', itemModel.toJSON())

  get: (id) ->
    @collection.get(id)?.toJSON()

  getItems: ->
    @collection.toJSON()

  update: (item) ->
    itemModel = @collection.get(item.id)
    return unless itemModel?

    itemModel.set(item)

  removeById: (id) ->
    itemModel = @collection.get(id)
    return unless itemModel?

    @collection.remove(itemModel)
    @trigger('change', @getItems())
    @trigger('item_removed', itemModel.toJSON())

  removeByName: (name) ->
    itemModel = @_getItemByName(name)
    return unless itemModel?

    @collection.remove(itemModel)
    @trigger('change', @getItems())
    @trigger('item_removed', itemModel.toJSON())

  hasItemWithId: (id) ->
    @collection.get(id)?

  hasItemWithName: (name) ->
    return false unless name?
    @_getItemByName(name)?

  _getItemByName: (name) ->
    @collection.find((item) => item.get('name').toLowerCase() is name.toLowerCase())

  _addVirtualIndex: (itemModel) ->
    itemModel.set virtualId: @maxVirtualIndex
