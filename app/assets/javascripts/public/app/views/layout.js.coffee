SCROLL_BASE = 'html, body'
ANIMATION_SPEED = 600
SCROLL_OFFSET_PX = 5

class App.Views.Layout extends View

  initialize: ->
    new App.Behaviors.Modals($el: @$el)
    new App.Behaviors.SmartScrollBar($el: @$el)

    @$window = $(window)
    @headersHeight = @$('[data-view="app#header"]').first().height() + @$('[data-view="app#sub_header"]').height()
    @$el.on('click', '[data-section-name]', _.bind(@goToSection, @))

    setTimeout(_.bind(@adjustMenuItemToScroll, @), 50)
    @$window.on('scroll', _.bind(@adjustMenuItemToScroll, @))

  goToSection: (e) ->
    e.preventDefault()
    $link = $(e.currentTarget)
    section = $link.data('section-name')
    screenHeight = @$window.height()
    documentHeight = @$el.height()

    sectionTopPos = @$sectionByName(section).offset().top
    # fix for sticky header
    sectionTopPos -= @headersHeight + SCROLL_OFFSET_PX

    # we don't want to scroll if there is no space to scroll
    if screenHeight + sectionTopPos > documentHeight
      sectionTopPos = documentHeight - screenHeight

    $(SCROLL_BASE).animate(scrollTop: sectionTopPos, ANIMATION_SPEED)

  $sections: ->
    @_$sections ?= $('[data-section]')

  $sectionByName: (name) ->
    @$sections().filter("[data-section='#{name}']")

  adjustMenuItemToScroll: ->
    topPos = @$window.scrollTop() + @headersHeight
    @$sections().each (i, el) =>
      $section = $(el)
      sectionTop = $section.offset().top - SCROLL_OFFSET_PX
      sectionBottom = sectionTop + $section.outerHeight(true)

      if topPos >= sectionTop and topPos < sectionBottom
        @pub('menu_item_changed', $section.data('section'))
