class App.ItemsList.Views.NewItemForm extends Dolphin.View

  els:
    form: 'form'
    cancelButton: '@items_list-cancel'

  events:
    'click @items_list-cancel': 'setAsClosed'
    'ajax:success form': 'provideNewItem'

  initialize: ->
    @listenTo(@itemsList, 'form_set_opened', @openForm)
    @listenTo(@itemsList, 'form_set_closed', @closeForm)

    if @$el.is(':visible') then @setAsOpened() else @setAsClosed()

  provideNewItem: (e, json) ->
    return unless json.success
    @itemsList.addFetchedItemData(json.html)
    @setAsClosed()

  setAsOpened: ->
    @itemsList.setFormAsOpened()

  setAsClosed: ->
    @itemsList.setFormAsClosed()

  openForm: ->
    return if @$el.is(':visible')

    @$el.hide()
      .removeClass('hidden')
      .fadeIn()
      .autofocus()

  closeForm: ->
    @$el.fadeOut('fast', => @$form().trigger('form:reset'))

