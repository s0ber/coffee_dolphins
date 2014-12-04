class App.ItemsList.Views.Item extends Dolphin.View

  els:
    itemTitle: '@item-title'
    infoContainer: '@item-info'
    editButton: '@edit_item_button'
    calcelEditButton: '@item-cancel_edit'
    likeButton: '@like_item_button'

  events:
    'click @like_item_button': 'toggleLike'
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
    $updateNotice = $('<span class="status is-gray"> — обновлено</span>').hide()
    $updateNotice.appendTo(@$itemTitle()).fadeIn()
    (-> $updateNotice.fadeOut(-> $updateNotice.remove())).delay(4000)

  toggleLike: (e) ->
    $likeButton = @$likeButton()
    return if $likeButton.hasClass('is-disabled')

    @utils.disableLink($likeButton)

    requestPath =
      if $likeButton.hasClass('is-liked')
        $likeButton.data('unlike-path')
      else
        $likeButton.data('like-path')

    $.post(requestPath, _method: 'put').done (json) =>
      @utils.enableLink($likeButton)
      $likeButton.toggleClass('is-liked')
      @showNotice(json.notice) if json.notice

# private

  id: ->
    @$el.data('item-id')

