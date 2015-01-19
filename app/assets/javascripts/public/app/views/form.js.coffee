class App.Views.Form extends View

  els:
    select: '.js-select-input'
    button: '.js-order_button'

  initialize: ->
    @redrawButtonText()
    @initCustomPlaceholder()

    @$select.on('change', _.bind(@redrawButtonText, @))

  initCustomPlaceholder: ->
    @$('input, textarea').placeholder()

  redrawButtonText: (e) ->
    quantity = parseInt(@$select.val(), 10)

    if quantity is 1
      @$button.html("Заказать за <b>#{@fullPrice()}</b> рублей &rarr;")
    else
      @$button.html("Заказать #{quantity} шт. за <b>#{@fullPrice() * quantity}</b> рублей &rarr;")

  fullPrice: ->
    @$el.data('full-price')
