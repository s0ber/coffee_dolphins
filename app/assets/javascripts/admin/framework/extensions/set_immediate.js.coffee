# setImmediate is function to make other function to be called asyncrounously,
# but without 4-500ms delay, which setTimeout does (standart at IE10)
# https://developer.mozilla.org/en-US/docs/DOM/window.setImmediate
window.setImmediate ||= do ->
  head = {}
  tail = head
  ID = Math.random()

  onmessage = (e) ->
    return if e.data isnt ID
    head = head.next
    func = head.func
    delete head.func

    func()

  if window.addEventListener
    window.addEventListener "message", onmessage, false
  else
    window.attachEvent "onmessage", onmessage

  if window.postMessage
    (func) ->
      tail = tail.next = { func }
      window.postMessage(ID, "*")
  else
    (func) ->
      setTimeout(func, 0)
