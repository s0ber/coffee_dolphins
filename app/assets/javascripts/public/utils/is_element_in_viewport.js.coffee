Utils.isElementInViewport = ($el) ->
  el = $el[0]
  rect = el.getBoundingClientRect()

  rect.top >= 0 and
    rect.left >= 0 and
    rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) and
    rect.right <= (window.innerWidth || document.documentElement.clientWidth)
