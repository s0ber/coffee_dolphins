Utils.getChar = (event) ->
  unless event.which
    return null if event.keyCode < 32
    return String.fromCharCode(event.keyCode)

  if event.which isnt 0 && event.charCode isnt 0
    return null if event.which < 32
    return String.fromCharCode(event.which)

  null

