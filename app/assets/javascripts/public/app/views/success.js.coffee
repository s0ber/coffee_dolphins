class App.Views.Success extends View

  initialize: ->
    setTimeout =>
      @pub('load_modal', [@$el.data('modal-path'), false])
    , 0

  modalPath: ->
    @_modalPath ?= @$el.data('modal-path')

  orderId: ->
    @_orderId ?= @$el.data('order-id')

