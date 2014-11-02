class App.ItemsList.Views.NewItemForm extends Dolphin.View

  els:
    form: 'form'
    cancelButton: '@items_list-cancel'

  events:
    'click @items_list-cancel': 'closeFormOnCancel'
    'ajax:success form': 'provideNewItem'

  initialize: ->
    @listenTo(@itemsList, 'form_set_opened', @_openForm)
    @listenTo(@itemsList, 'form_set_closed', @_closeForm)

  closeFormOnCancel: ->
    return if @$cancelButton().hasClass('is-disabled')
    @itemsList.setFormAsClosed()

  provideNewItem: (e, json) ->
    return unless json.success
    @itemsList.addFetchedItemData(json.html)
    @itemsList.setFormAsClosed()

# private

  _openForm: ->
    return if @$el.is(':visible')

    @$el.hide()
      .removeClass('hidden')
      .fadeIn()
      .autofocus()

  _closeForm: ->
    @$el.fadeOut('fast', => @$form().trigger('form:reset'))

