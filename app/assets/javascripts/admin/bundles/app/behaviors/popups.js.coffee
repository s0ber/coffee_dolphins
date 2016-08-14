class App.Behaviors.Popups extends Dolphin.View

  els:
    pagePopupsWrapper: '@page-popups_wrapper'

  initialize: ->
    @listen('popups:show', @openGenericPopup)

  openGenericPopup: (m) ->
    {$button, html} = m.body
    @openPopup.bind(@, $button, {html}).delay(0)

  openPopup: ($button, options = {}) ->
    @$button = $button
    @$popup.remove() if @$popup?.exists()

    @$button.addClass 'is-opened'

    if options.html
      @renderPopup(options.html)
      @showPopup()

  renderPopup: (html) ->
    @$popup = $(@renderTemplate('popup', html: html))
    @append(@$pagePopupsWrapper(), @$popup)

  showPopup: ->
    @locatePopup()
    @$popup.fadeIn(100)
    @$popup.data('$button', @$button)

    @bindCloseEvents()

  locatePopup: ->
    $pagePopupsWrapper = @$pagePopupsWrapper()

    top = @$button.offset().top -
      $pagePopupsWrapper.offset().top +
      @$button.outerHeight() + 10
    right = $pagePopupsWrapper.width() -
      (@$button.offset().left - $pagePopupsWrapper.offset().left) -
      (@$button.outerWidth() / 2) - (@$popup.outerWidth() / 2)

    # we're moving pop-up point to the left edge of the button
    # if there is not enough space for it on a small screen
    outerSpaceLeft = ($(window).width() - $pagePopupsWrapper.width()) / 2
    if outerSpaceLeft + right < 0
      right += (@$button.outerWidth() / 2)

    @$popup.css(top: top, right: right)

  bindCloseEvents: ->
    @$button.on('remove', => @closePopup() if @$popup?)

    @$el
      .on "keyup.popup:hide", (e) => @closePopup() if e.keyCode is 27
      .on "click.popup:hide", (e) =>
        $clickedEl = $(e.target)
        $popup = $clickedEl.closest('@popup')
        return if $popup.exists() and $popup.is(@$popup)
        @closePopup()

  closePopup: ->
    @$button.removeClass('is-opened')
    @unbindCloseEvents()
    @$popup.hide()

  unbindCloseEvents: ->
    @$el.off(".popup:hide")
