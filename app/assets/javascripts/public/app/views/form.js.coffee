class App.Views.Form extends View

  els:
    select: '.js-select-input'
    button: '.js-order_button'

  initialize: ->
    @initCustomPlaceholder()

    @$select.on('change', _.bind(@redrawButtonText, @))

    # @initApishopsForm()

    @$button.on('click', _.bind(@submitForm, @))

    @__trackOrderFormOpened()
    @__trackSuccessfulOrder()

  submitForm: ->
    @$form().submit()
    false

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
    @$el.autofocus()
    return if @$button.data('show-price') is false

    quantity = parseInt(@$select.val(), 10)

    if quantity is 1
      @$button.html("Заказать за <b>#{@fullPrice()}</b> рублей &rarr;")
    else
      @$button.html("Заказать #{quantity} шт. за <b>#{@fullPrice() * quantity}</b> рублей &rarr;")

  $form: ->
    @$el.find('form')

  $phoneField: ->
    @$el.find('input[type="text"]')

  fullPrice: ->
    @$el.data('full-price')

# private
  __trackOrderFormOpened: ->
    return if window.__orderFormOpened

    tracking.trackEvent('order_form_opened')
    window.__orderFormOpened = true

  __trackSuccessfulOrder: ->
    @$form().on 'submit', =>
      return if $.trim(@$phoneField().val()) is ''
      tracking.trackEvent('order_successed')

