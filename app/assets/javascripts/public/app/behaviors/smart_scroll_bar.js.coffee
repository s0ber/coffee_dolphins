class App.Behaviors.SmartScrollBar extends View

  initialize: ->
    @$window = $(window)
    @$body = $('body')
    @$modalLayer = @$('.js-modals-layer')
    @$modalContainer = @$('.js-modals-container')

    @fixScroll()

  # fixes scroll width, so content doesn't jump when scroll disappears
  fixScroll: ->
    @_fixScrollFunction()
    @$window.on 'resize', @_fixScrollFunction.bind(@)

  _fixScrollFunction: do ->
    lastDocumentWidth = null

    return ->
      w = window
      de = document.documentElement
      sbw = @scrollWidth()
      windowWidth = Math.max(parseInt(w.innerWidth, 10), parseInt(de.clientWidth, 10))
      documentWidth = windowWidth - sbw

      if documentWidth != lastDocumentWidth
        lastDocumentWidth = documentWidth
        @$modalLayer.width(windowWidth)
        @$modalContainer.width(documentWidth)
        $('.js-scroll_fix').each (i, section) -> $(section).width(documentWidth)

  scrollWidth: ->
    @_scrollWidth ?= do =>
      $fakeBlock = $('<div />')
        .html('<div style="height: 75px;">1<br>1</div>')
        .css(
          overflowY: 'scroll',
          position: 'absolute',
          width: '50px',
          height: '50px'
        )

      @$body.append($fakeBlock)
      scrollWidth = Math.max(0, $fakeBlock[0].offsetWidth - $fakeBlock[0].firstChild.offsetWidth)
      $fakeBlock.remove()

      scrollWidth

