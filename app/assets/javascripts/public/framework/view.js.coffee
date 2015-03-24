class @View

  cid = 0

  constructor: (options) ->
    @cid = "view-#{++cid}"

    @$el = $(options.el || options.$el)
    @el = @$el[0]

    @__initEls()

    @initialize?()

  onUnload: ->
    @unsub()
    @unload?()

  $: (selector) ->
    @$el.find(selector)

  sub: (eventName, handler) ->
    handler = _.bind(handler, @)
    eventName = "#{eventName}.#{@cid}"

    Utils.PubSub.on eventName, (e, args...) =>
      handler.apply(@, args)

  pub: (eventName, args...) ->
    Utils.PubSub.trigger(eventName, args...)

  unsub: ->
    Utils.PubSub.off(".#{@cid}")

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

