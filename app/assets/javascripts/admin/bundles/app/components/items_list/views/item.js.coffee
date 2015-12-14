class App.ItemsList.Views.Item extends Dolphin.View

  els:
    infoContainer: '@item-info'
    editButton: '@edit_item_button'

  events:
    'ajax:success @item-remove_button': 'removeItem'

  initialize: ->
    @applyBehavior 'EditableItem' if @blockPath()
    @itemsList.addItem id: @id()

  removeItem: ->
    @$el.fadeOut =>
      @$el.remove()
      @itemsList.removeItemById(@id())

# private

  blockPath: ->
    @$el.data('block-path')

  id: ->
    @$el.data('item-id')

