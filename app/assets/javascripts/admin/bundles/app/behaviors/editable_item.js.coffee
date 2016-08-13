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
    'modal_button:update [data-modal]': 'updateItem'

  initialize: ->
    @applyBehavior 'Dynamic' if @blockPath()

  openEditForm: (e, json) ->
    e.stopPropagation()
    @utils.disableLink(@$editButton(), true)
    @$infoContainer().hide()
    @after(@$infoContainer(), json.html)
    @$el.autofocus()

  closeEditForm: ->
    @utils.enableLink(@$editButton(), true)
    @$infoContainer()
      .next().remove().end()
      .show()

  updateItem: (e) ->
    e.stopPropagation()
    if @blockPath()
      @behaviors.Dynamic.redraw().done @showUpdateNotice.bind(@)
    else if @redirectPath()
      @emit('page:load', @redirectPath())

  showUpdateNotice: ->
    return unless @$itemTitle().exists()
    $updateNotice = $('<span class="status is-gray"> — обновлено</span>').hide()
    $updateNotice.appendTo(@$itemTitle()).fadeIn()
    (-> $updateNotice.fadeOut(-> $updateNotice.remove())).delay(4000)

# getters

  blockPath: ->
    @_blockPath ?= @$el.data('block-path')

  redirectPath: ->
    @_redirectPath ?= @$el.data('redirect-path')

