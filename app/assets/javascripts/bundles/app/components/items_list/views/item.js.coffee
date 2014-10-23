class App.ItemsList.Views.Item extends Dolphin.View

  els:
    infoContainer: '@item-info'
    editButton: '@edit_item_button'
    calcelEditButton: '@item-cancel_edit'

  events:
    'ajax:success @remove_item_button': 'removeItem'
    'ajax:success @edit_item_button': 'openEditForm'
    'click @item-cancel_edit': 'closeEditForm'
    'ajax:success form': 'updateItem'

  initialize: ->
    @itemsList.addItem id: @id()

  removeItem: ->
    @itemsList.removeItemById(@id())
    @$el.fadeOut(=> @$el.remove())

  updateItem: ->

  openEditForm: (e, json) ->
    @$editButton().addClass('is-disabled')
    @$infoContainer().hide()
    @after(@$infoContainer(), json.html)
    @$el.autofocus()

  closeEditForm: ->
    @$editButton().removeClass('is-disabled')
    @$infoContainer()
      .next().remove().end()
      .show()

# private

  id: ->
    @$el.data('item-id')

