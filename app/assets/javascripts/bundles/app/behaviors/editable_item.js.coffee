class App.Behaviors.EditableItem extends Dolphin.View

  els:
    itemTitle: '@editable_item-title'
    infoContainer: '@editable_item-info'
    editButton: '@editable_item-edit_button'
    calcelEditButton: '@editable_item-cancel_edit'

  events:
    'ajax:success @editable_item-edit_button': 'openEditForm'
    'click @editable_item-cancel_edit': 'closeEditForm'
    'ajax:success form': 'updateItem'

  initialize: ->
    @applyBehavior 'Dynamic'

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
