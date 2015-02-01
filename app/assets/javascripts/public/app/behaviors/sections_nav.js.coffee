SCROLL_BASE = 'html, body'
ANIMATION_SPEED = 600
SCROLL_OFFSET_PX = 5

class App.Behaviors.SectionsNav extends View

  initialize: ->
    @$window = $(window)
    @headersHeight = @$('[data-view="app#header"]').first().height() + @$('[data-view="app#sub_header"]').height()
    @$el.on('click', '[data-section-name]', _.bind(@goToSection, @))

    setTimeout(_.bind(@adjustMenuItemToScroll, @), 50)
    @$window.on('scroll', _.bind(@adjustMenuItemToScroll, @))

    @$window.on 'hashchange', (e) =>
      e.preventDefault()
      sectionName = window.location.hash.replace(/^#/, '')
      @goToSectionByName(sectionName, false)
      return false

  goToSection: (e) ->
    e.preventDefault()
    $link = $(e.currentTarget)

    @goToSectionByName($link.data('section-name')).done (sectionName) ->
      window.location.hash = sectionName

  goToSectionByName: (section, animate = true) ->
    dfd = new $.Deferred()
    screenHeight = @$window.height()
    documentHeight = @$el.height()

    $section = @$sectionByName(section)
    sectionTopPos = $section.offset().top

    # fix for sticky header
    sectionTopPos -= @headersHeight + SCROLL_OFFSET_PX

    # we don't want to scroll if there is no space to scroll
    if screenHeight + sectionTopPos > documentHeight
      sectionTopPos = documentHeight - screenHeight

    if animate
      $(SCROLL_BASE).animate scrollTop: sectionTopPos, ANIMATION_SPEED, ->
        $section.autofocus() if section is 'main'
        dfd.resolve(section)
    else
      $(SCROLL_BASE).scrollTop(sectionTopPos)
      $section.autofocus() if section is 'main'
      dfd.resolve(section)

    dfd.promise()

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
