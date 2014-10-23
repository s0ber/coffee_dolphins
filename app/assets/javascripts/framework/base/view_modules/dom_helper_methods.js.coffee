@DomHelpersModule =

  html: ($el, html) ->
    Vtree.DOM.html($el, html)

  after: ($el, $insertedEl) ->
    Vtree.DOM.after($el, $insertedEl)

  append: ($parentEl, $el) ->
    Vtree.DOM.append($parentEl, $el)

  after: ($el, $insertedEl) ->
    Vtree.DOM.after($el, $insertedEl)

