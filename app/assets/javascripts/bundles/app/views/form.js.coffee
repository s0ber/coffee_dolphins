class App.Views.Form extends Dolphin.View

  els:
    submitButton: '[type="submit"]'

  events:
    'keydown .is-invalid': 'removeErrorOnKeydown'
    'keypress .is-invalid': 'removeErrorOnKeypress'
    'change .is-invalid': 'removeErrorOnChange'
    'ajax:before': 'processBeforeSubmit'
    'ajax:error': 'processErrorSubmit'
    'ajax:custom_error': 'displayCustomErrors'
    'ajax:success': 'processSubmit'
    'form:reset': 'reset'

  processBeforeSubmit: ->
    @removeAllErrors()
    @showLoader()

  processSubmit: (e, json) ->
    @displayNotifications(json)
    @followBrowserRedirect(json.browser_redirect) if json.browser_redirect
    @followRedirect(json.redirect) if json.redirect

  processErrorSubmit: (e, xhr) ->
    @hideLoader()
    json = JSON.parse(xhr.responseText)

    if json.browser_redirect
      @followBrowserRedirect(json.browser_redirect)
    else
      @displayNotifications(json)
      @showErrors(json.errors)

  displayCustomErrors: (e, errors) ->
    @hideLoader()
    @showErrors(errors)

  showErrors: (errors) ->
    for name, messages of errors
      $field = @$("[name='#{@entity()}[#{name}]']")
      $fieldWrap = $field.closest('.js-field_wrapper')
      $label = $fieldWrap.find('label.control-label .label_wrap')

      $fieldWrap.addClass('is-invalid')
      $error = $("<span class='error'> — #{messages.join(', ')}</span>").hide()
      $error.insertAfter($label).fadeIn()

  removeAllErrors: ->
    @$('.is-invalid').removeClass('is-invalid')
    @$('.error').remove()

  removeErrorOnChange: (e) ->
    @removeError $(e.currentTarget)

  removeErrorOnKeydown: (e) ->
    char = @utils.getChar(e)
    isBackspace = (e.keyCode or e.which) is 8

    @removeError $(e.currentTarget) if isBackspace or char?

  removeErrorOnKeypress: (e) ->
    @removeError $(e.currentTarget)

  removeError: ($field) ->
    $fieldWrap = $field.closest('.js-field_wrapper')
    $error = $fieldWrap.find('.error')

    $fieldWrap.removeClass('is-invalid')
    $error.fadeOut(-> $error.remove())

  reset: ->
    @removeAllErrors()
    @hideLoader()
    @$el[0].reset()

  followBrowserRedirect: (path) ->
    window.location.replace(path)

  followRedirect: (path) ->
    if path is 'back'
      @emit('page:reload')
    else
      @emit('page:load', path)

  displayNotifications: (json) ->
    ['alert', 'notice'].each (type) =>
      @emit("flash_message:#{type}", json[type]) if json[type]

  showLoader: (e) ->
    @utils.showButtonLoader @$submitButton()

  hideLoader: (e) ->
    @utils.hideButtonLoader @$submitButton()

  entity: ->
    @$el.data('entity')
