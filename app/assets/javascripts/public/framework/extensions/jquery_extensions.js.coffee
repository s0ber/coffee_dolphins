$.fn.autofocus = ->
  return if $.browser.msie

  @find('input, textarea, select').not(':hidden')
    .first()
    .filter('[type="text"], textarea, select')
    .focus().select()

  @

