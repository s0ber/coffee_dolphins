$.fn.exists = -> @length isnt 0

# Serializes form to JSON (http://css-tricks.com/snippets/jquery/serialize-form-to-json/)
$.fn.serializeObject = ->
  o = {}
  a = @serializeArray()

  $.each a, () ->
    if o[@name] and /\[\]$/.test(@name)
      o[@name] = [o[@name]] if not o[@name].push
      o[@name].push(@value || '')

    else
      o[@name] = @value or ''

  o

# This plugin depends on $.fn.serializeObject
$.fn.getFormData = ->
  $form = $(@)
  formData = new FormData()

  for own name, value of $form.serializeObject()
    formData.append(name, value)

  $form.find(':file').each ->
    $fileInput = $(@)
    # TODO: Find a way to support few files with Rails
    file = $fileInput[0].files[0]
    if file
      formData.append($fileInput.attr('name'), file)

  formData

$.fn.autofocus = ->
  @find('input, textare').not(':hidden')
    .first()
    .filter('[type="text"], textarea')
    .focus()

  @

