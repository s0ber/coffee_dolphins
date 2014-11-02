class App.ItemsList.Views.Index extends Dolphin.View

  els:
    openFormButton: '@items_list-show_form'
    listWrapper: '@items_list-list_wrapper'
    emptyListMessage: '@items_list-empty_list_message'

  events:
    'click @items_list-show_form': 'setFormAsOpened'

  initialize: ->
    @itemsList = new App.ItemsList.ViewModels.ItemsList()
    @addComponentData {@itemsList}

    @listenTo(@itemsList, 'form_set_opened', @disableFormButton)
    @listenTo(@itemsList, 'form_set_closed', @enableFormButton)
    @listenTo(@itemsList, 'item_data_fetched', @renderNewItem)

    @observe(@itemsList, @toggleEmptyListMessage)

  setFormAsOpened: ->
    @itemsList.setFormAsOpened()

  disableFormButton: ->
    @$openFormButton().attr(disabled: true)

  enableFormButton: ->
    @$openFormButton().removeAttr('disabled')

  renderNewItem: (itemHtml) ->
    $newItem = $(itemHtml)

    @append(@$listWrapper(), $newItem)
    @utils.scrollToEl($newItem)
    $newItem.blink()

  toggleEmptyListMessage: ->
    @$emptyListMessage().toggleClass('hidden', not @itemsList.isEmpty())

