$ ->
  $('body').attr('onunload', '')

  if (/iphone|ipod|ipad.*os 5/gi).test(navigator.appVersion)
    $(window).on 'pageshow', (e) ->
      return unless e.originalEvent.persisted
      document.body.style.display = 'none'
      location.reload()
