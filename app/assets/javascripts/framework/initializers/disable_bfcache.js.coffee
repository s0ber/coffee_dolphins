# Some modern browsers save whole browser page (including js)
# in so-called back-forward cache, which ruins history API in some cases.
# This code prevents loading pages from bfcache.
$('body').attr('onunload', '')

if (/iphone|ipod|ipad.*os 5/gi).test(navigator.appVersion)
  $(window).on 'pageshow', (e) ->
    return unless e.originalEvent.persisted
    document.body.style.display = 'none'
    location.reload()

