class App.Views.Form extends View

  els:
    select: '.js-select-input'
    button: '.js-order_button'

  initialize: ->
    @initCustomPlaceholder()

    @$select.on('change', _.bind(@redrawButtonText, @))

    @initApishopsForm()

    @$button.on('click', _.bind(@submitForm, @))

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
    quantity = parseInt(@$select.val(), 10)

    if quantity is 1
      @$button.html("Заказать за <b>#{@fullPrice()}</b> рублей &rarr;")
    else
      @$button.html("Заказать #{quantity} шт. за <b>#{@fullPrice() * quantity}</b> рублей &rarr;")

    @$el.autofocus()

  $form: ->
    @$el.find('form')

  $phoneField: ->
    @$el.find('input[type="text"]')

  fullPrice: ->
    @$el.data('full-price')

# private

  __trackSuccessfulOrder: ->
    @$form().on 'submit', =>
      return if $.trim(@$phoneField().val()) is ''

      if @$form().is('#top_form')
        gaWidget.trackEvent 'Оформление заказа', 'Кнопка заказать', 'Верхняя форма'
      else
        gaWidget.trackEvent 'Оформление заказа', 'Кнопка заказать', 'Нижняя форма'
