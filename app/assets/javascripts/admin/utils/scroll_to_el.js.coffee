Utils.scrollToEl = ($el, force = false) ->
  $html = $('html')
  $body = $('body')
  elTopPos = $el.offset().top
  scrollPos = Math.max($body.scrollTop(), $html.scrollTop())
  screenHeight = $(window).height()

  if $el.length && (elTopPos < scrollPos or elTopPos > (scrollPos + screenHeight) or force)
    $('html, body').scrollTop(parseInt($el.offset().top - 10, 10))

