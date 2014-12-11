@DomHelpersModule =

  html: ($el, html) ->
    Vtree.DOM.html($el, html)

  after: ($el, $insertedEl) ->
    Vtree.DOM.after($el, $insertedEl)

  append: ($parentEl, $el) ->
    Vtree.DOM.append($parentEl, $el)

  after: ($el, $insertedEl) ->
    Vtree.DOM.after($el, $insertedEl)

  updateHtml: (html) ->
    $newEl = $(html)

    @$el.attr(class: $newEl.attr('class'))
    Vtree.DOM.html(@$el, $newEl.html())

