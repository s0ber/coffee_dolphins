class App.Behaviors.Sortable extends Dolphin.View

  els:
    sortable: '@sortable'

  events:
    'focus input': 'unloadSorting'
    'blur input': 'resetSorting'

  initialize: ->
    @initSorting()
    @listen('page:loaded', @resetSorting)
    @$sortable().on('sortupdate', @handleSortUpdate.bind(@))

  initSorting: ->
    @$sortable().sortable(handle: '@sortable-handle')

  unloadSorting: ->
    @$sortable().sortable('destroy')

  resetSorting: ->
    @unloadSorting()
    @initSorting()

  onSortUpdate: (fn) ->
    @_sortFn = fn

  handleSortUpdate: ->
    @_sortFn?()
