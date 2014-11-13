# Returns new value for field
# Returns null if new value can't be read via given event type
Utils.getNewFieldVal = (e) ->
  $el = $(e.currentTarget)
  val = $el.val()
  pos = $el.range()
  keyCode = e.which || e.keyCode

  if e.type is 'keydown'
    switch keyCode
      when 8
        val.substring(0, pos.start - 1) + val.substring(pos.end)
      when 46
        val.substring(0, pos.start) + val.substring(pos.end + 1)
      else
        null

  else if e.type is 'keypress' or e.type is 'cut'
    newChar = Utils.getChar(e)
    restrictedKeys = [37, 38, 39, 40] # in FF, arrows in input field trigger keypress, which sucks

    return null if e.ctrlKey or e.altKey or e.metaKey or newChar is null or $.inArray(keyCode, restrictedKeys) != -1
    val.substring(0, pos.start) + newChar + val.substring(pos.end)

  else
    null

