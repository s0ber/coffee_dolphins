@DomHelpersModule =

  html: ($el, html) ->
    Vtree.DOM.html($el, html)

  after: ($el, $insertedEl) ->
    Vtree.DOM.after($el, $insertedEl)

