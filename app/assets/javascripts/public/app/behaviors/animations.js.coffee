# DON'T TRY TO UNDERSTAND THIS

ANIMATED_ELS = [
  '.animate-show'
  '.animate-show_fast'
  '.animate-show_zoom'
].join(', ')

class App.Behaviors.Animations extends View

  initialize: ->
    setTimeout =>
      scrollTopPos = Math.max($('html').scrollTop(), $('body').scrollTop())

      if not @transitionsSupported or scrollTopPos > $(window).height()
        $('body').addClass('no-transitions')
      else
        @els = _.toArray($(ANIMATED_ELS))
        @fireAnimations()
        $(window).on 'scroll', _.throttle(_.bind(@fireAnimations, @), 200)
    , 100

  fireAnimations: ->
    return if @els.length is 0
    animatedEls = []

    for i in [0...@els.length]
      el = @els[i]
      rect = el.getBoundingClientRect()
      if rect.top >= 0 and rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) + 150
        animatedEls.push(el)

    if animatedEls.length > 0 and (index = _.indexOf(@els, animatedEls[0])) > 0
      newEls = @els.splice(0, index)
      animatedEls.unshift(newEls...)

    @els = _.without(@els, animatedEls...)

    _.each animatedEls, (el, i) =>
      AsyncFn.addToCallQueue _.bind(@showAnimationForEl, @, el)

  showAnimationForEl: (el) ->
    dfd = new $.Deferred()
    $el = $(el).addClass('is-animated')
    isDeferred = $el.hasClass('js-wait_animation')

    if isDeferred
      $el.afterTransition -> dfd.resolve()
    else
      setTimeout((-> dfd.resolve()), 150)

    dfd.promise()

# private

  transitionsSupported: do ->
    fakediv = document.createElement('div')
    supported = false
    prefixes = 'ms Ms o O webkit Webkit moz Moz'.split(' ')

    for prefix in prefixes
      if fakediv.style[prefix + 'Transition']?
        supported = true
        break

    fakediv = null
    supported

