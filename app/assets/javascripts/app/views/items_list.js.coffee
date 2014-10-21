class App.Views.ItemsList extends App.View

  events:
    'click .list-item': 'selectItem'

  initialize: ->
    @historyWidget = Histo.addWidget(id: 'items_list')
    @setInitialState()
    @setPoppedStateProcessing()

  setInitialState: ->
    $selectedItem = @$('.list-item.is-active')
    @historyWidget.replaceInitialState('selected_item_id': $selectedItem.data('item-id') || 0)

  setPoppedStateProcessing: ->
    @historyWidget.onPopState (state, path, dfd) =>
      itemId = state['selected_item_id']

      if itemId is 0
        itemPath = @$el.data('no-item-url')
      else
        $item = @$itemById(itemId)
        itemPath = $item.data('item-url')

      dfd.fail @abortCurrentRequest.bind(@)
      @createNewRequest(
        $.getJSON(itemPath).done (json) =>
          if itemId is 0
            @$('.list-item').removeClass('is-active')
          else
            @setItemAsSelected($item)

          @html(@$selectedItemWrapper(), json.html)
          dfd.resolve()
      )

  selectItem: (e) ->
    $item = $(e.currentTarget)
    path = new URI(location.href)
    path.setSearch('item_id': $item.data('item-id'))

    @createNewRequest(
      $.getJSON($item.data('item-url')).done (json) =>
        @historyWidget.pushState(path.toString(), 'selected_item_id': $item.data('item-id'))
        @setItemAsSelected($item)
        @html(@$selectedItemWrapper(), json.html)
    )

  setItemAsSelected: ($item) ->
    $item
      .siblings()
        .removeClass('is-active')
        .end()
      .addClass('is-active')

  # accessors

  $selectedItemWrapper: ->
    @_$selectedItemWrapper ?= @$('@items_list-item_wrapper')

  $itemById: (id) ->
    @$('.list-item').filter("[data-item-id=#{id}]")

