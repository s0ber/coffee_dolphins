class @View

  constructor: (options) ->
    @$el = $(options.el || options.$el)
    @el = @$el[0]

    @__initEls()

    @initialize?()

  $: (selector) ->
    @$el.find(selector)

  sub: (eventName, handler) ->
    handler = _.bind(handler, @)
    Utils.PubSub.on eventName, (e, args...) =>
      handler.apply(@, args)

  pub: (eventName, args...) ->
    Utils.PubSub.trigger(eventName, args...)

  html: ($el, html) ->
    Vtree.DOM.html($el, html)

  append: ($parentEl, $appendedEl) ->
    Vtree.DOM.append($parentEl, $appendedEl)

  appendAsync: ($parentEl, $appendedEl) ->
    Vtree.DOM.appendAsync($parentEl, $appendedEl)

  __initEls: ->
    return unless @els?

    for own name, selector of @els
      @["$#{name}"] = @$(selector)

