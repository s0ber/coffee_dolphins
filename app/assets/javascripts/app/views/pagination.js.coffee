class App.Views.Pagination extends App.View

  events:
    'click a.pagination-page': 'loadNewPage'

  initialize: ->
    @historyWidget = Histo.addWidget(id: 'search_pagination')
    @setInitialState()
    @setPoppedStateProcessing()

  setInitialState: ->
    path = location.href
    currentPageNumber = @getPageNumberFromPath(path)

    @historyWidget.replaceInitialState('page_number': currentPageNumber)

  setPoppedStateProcessing: ->
    @historyWidget.onPopState (state, path, dfd) =>
      dfd.fail @abortCurrentRequest.bind(@)
      @createNewRequest(
        $.getJSON(path).done (json) =>
          @utils.scrollTop()
          @html(@$el, json.html)
          dfd.resolve()
      )

  loadNewPage: (e) ->
    e.preventDefault()

    $link = $(e.currentTarget)
    path = $link.attr('href')
    newPageNumber = @getPageNumberFromPath(path)

    # if 'modifier' widgets states were added in current state, we should remove them from request
    # path = HistoryApi.filterPushPath($link.attr('href'))
    path = URI(path).removeSearch('item_id')

    @createNewRequest(
      $.getJSON(path).done (json) =>
        @utils.scrollTop()
        @historyWidget.pushState(path, 'page_number': newPageNumber)
        @html(@$el, json.html)
    )

  # private

  getPageNumberFromPath: (path) ->
    if page = URI(path).search(true).page
      parseInt(page, 10)
    else
      1

