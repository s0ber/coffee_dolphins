class Dolphin.ViewModel extends Frames.Model

  setCollection: (@collection, options = {}) ->
    @collectionEntity = options.for or 'item'

    @listenTo(@collection, 'add', @_triggerCollectionChange)
    @listenTo(@collection, 'remove', @_triggerCollectionChange)

  addToCollection: (itemModel) ->
    @collection.add(itemModel)
    @trigger("#{@collectionEntity}_added", itemModel.toJSON())

  removeFromCollection: (itemModel) ->
    @collection.remove(itemModel)
    @trigger("#{@collectionEntity}_removed", itemModel.toJSON())

  isEmpty: ->
    @collection.size() is 0

  size: ->
    @collection.size()

  toJSON: ->
    @collection.toJSON()

  _triggerCollectionChange: ->
    @trigger('change')

