class App.Views.Select extends View

  els:
    label: '.js-select-label'
    input: '.js-select-input'
    options: 'option'

  initialize: ->
    @applyLabel()
    @$input
      .on('change', @applyLabel.bind(@))
      .on('focus', @applyFocus.bind(@))
      .on('blur', @removeFocus.bind(@))

  applyLabel: ->
    @$label.text(@$selectedOption().text())

  applyFocus: ->
    @$el.addClass('is-focused')

  removeFocus: ->
    @$el.removeClass('is-focused')

  value: ->
    val = @$input.val()

  $selectedOption: ->
    @$options.filter("[value='#{@value()}']")
