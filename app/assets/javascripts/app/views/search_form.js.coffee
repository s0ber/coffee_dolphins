class App.Views.SearchForm extends App.View

  events:
    'click @search_form-radio': 'changeActiveRadio'

  initialize: ->
    @model = {}

    @setInitialValue()
    @initHistoryApi()

  setInitialValue: ->
    @setValue @fieldValue()

  changeActiveRadio: (e) ->
    $radio = $(e.currentTarget)
    return if $radio.hasClass 'is-active'
    value = $radio.data 'value'

    @setValue value

    path = @getQueryPath()
    @createNewRequest(
      $.getJSON(path).done (json) =>
        @historyWidget.pushState(path, 'query_model': Object.clone(@model))
        @html(@$listWrapper(), json.html)
    )

  setActiveRadio: ->
    @$radios().removeClass('is-active')
    @$radios()
      .filter("[data-value=#{@value()}]")
      .addClass('is-active')

  # accessors

  setValue: (value) ->
    @model[@fieldName()] = value
    @setActiveRadio()

  value: ->
    @model[@fieldName()]

  # getters

  $radios: ->
    @_$radios ?= @$('@search_form-radio')

  $listWrapper: ->
    $('[data-view="app#pagination"]')

  fieldName: ->
    @_fieldName ?= @$el.data('field-name')

  fieldValue: ->
    @$el.data('value')

  getQueryString: ->
    $.param(@model)

  getQueryPath: ->
    "#{location.pathname}?#{@getQueryString()}"

  # history API processing

  initHistoryApi: ->
    @historyWidget = Histo.addWidget(id: 'search_form')
    @setInitialState()
    @setPoppedStateProcessing()

  setInitialState: ->
    @historyWidget.replaceInitialState 'query_model': Object.clone(@model)

  setPoppedStateProcessing: ->
    @historyWidget.onPopState (state, path, dfd) =>
      model = state['query_model']
      newValue = model[@fieldName()]
      @setValue newValue

      dfd.fail @abortCurrentRequest.bind(@)
      @createNewRequest(
        $.getJSON(path).done (json) =>
          @html(@$listWrapper(), json.html)
          dfd.resolve()
      )
