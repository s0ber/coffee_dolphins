class App.Views.Success extends View

  initialize: ->
    @inline = @$el.data('inline') is true

    setTimeout =>
      if @inline
        $modalTemplate = $("##{@$el.data('inline-modal')}")
        @pub('show_modal', [{html: $modalTemplate.html()}, false])
      else
        @pub('load_modal', [@$el.data('modal-path'), false])
    , 0

  modalPath: ->
    @_modalPath ?= @$el.data('modal-path')

  orderId: ->
    @_orderId ?= @$el.data('order-id')

