class App.Views.Form extends View

  els:
    select: '.js-select-input'
    button: '.js-order_button'

  initialize: ->
    @initCustomPlaceholder()

    @redrawButtonText()
    @$select.on('change', _.bind(@redrawButtonText, @))

    @initApishopsForm()

  initApishopsForm: ->
    @$form().apishopsForm
      type: 'inline'
      form: "##{@$form().attr('id')}"
      siteId: @$el.data('site-id')
      productId: @$el.data('product-id')
      price: @fullPrice()
      priceRound: @fullPrice()
      wpId: @$el.data('article-id')
      successUrl: @$el.data('success-path') + '?order_id='

  initCustomPlaceholder: ->
    @$('input, textarea').placeholder()

  redrawButtonText: (e) ->
    quantity = parseInt(@$select.val(), 10)

    if quantity is 1
      @$button.html("Заказать за <b>#{@fullPrice()}</b> рублей &rarr;")
    else
      @$button.html("Заказать #{quantity} шт. за <b>#{@fullPrice() * quantity}</b> рублей &rarr;")

    @$el.autofocus()

  $form: ->
    @$el.find('form')

  fullPrice: ->
    @$el.data('full-price')
