Utils.scrollTop = (value = null) ->
  if value?
    $('html, body').scrollTop(value)
  else
    $('html, body').scrollTop(0)
