class App.ItemsList.Views.Item extends Dolphin.View

  els:
    itemTitle: '@item-title'
    infoContainer: '@item-info'
    editButton: '@edit_item_button'
    calcelEditButton: '@item-cancel_edit'

  events:
    'ajax:success @remove_item_button': 'removeItem'
    'ajax:success @edit_item_button': 'openEditForm'
    'click @item-cancel_edit': 'closeEditForm'
    'ajax:success form': 'updateItem'

  initialize: ->
    @applyBehavior 'Dynamic'
    @itemsList.addItem id: @id()

  removeItem: ->
    @$el.fadeOut =>
      @$el.remove()
      @itemsList.removeItemById(@id())

  openEditForm: (e, json) ->
    @utils.disableLink(@$editButton(), true)
    @$infoContainer().hide()
    @after(@$infoContainer(), json.html)
    @$el.autofocus()

  closeEditForm: ->
    @utils.enableLink(@$editButton(), true)
    @$infoContainer()
      .next().remove().end()
      .show()

  updateItem: ->
    @behaviors.Dynamic.redraw().done @showUpdateNotice.bind(@)

  showUpdateNotice: ->
    return unless @$itemTitle().exists()
    $updateNotice = $('<span class="status is-gray"> — обновлено</span>').hide()
    $updateNotice.appendTo(@$itemTitle()).fadeIn()
    (-> $updateNotice.fadeOut(-> $updateNotice.remove())).delay(4000)

# private

  id: ->
    @$el.data('item-id')

