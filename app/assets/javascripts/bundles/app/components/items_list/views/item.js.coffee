class App.ItemsList.Views.Item extends Dolphin.View

  els:
    infoContainer: '@item-info'
    editButton: '@edit_item_button'
    calcelEditButton: '@item-cancel_edit'

  events:
    'ajax:success @item-remove_button': 'removeItem'

  initialize: ->
    @applyBehavior 'EditableItem'
    @itemsList.addItem id: @id()

  removeItem: ->
    @$el.fadeOut =>
      @$el.remove()
      @itemsList.removeItemById(@id())

# private

  id: ->
    @$el.data('item-id')

