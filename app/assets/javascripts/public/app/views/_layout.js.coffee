class App.Views.Layout extends View

  initialize: ->
    new App.Behaviors.Modals($el: @$el)
    new App.Behaviors.SmartScrollBar($el: @$el)
    new App.Behaviors.SectionsNav($el: @$el)
    new App.Behaviors.Animations($el: @$el)

    setTimeout(_.bind(@track15Sec, @), 15000)
    @sub('menu_item_changed', _.bind(@trackSectionsScroll, @))

  track15Sec: ->
    tracking.trackEvent('15_sec')

  trackSectionsScroll: (sectionName) ->
    if sectionName is 'middle_page_order'
      return if @middlePageScrolled
      tracking.trackEvent('middle_page_scrolled')
      @middlePageScrolled = true

    if sectionName is 'footer_order'
      return if @bottomPageScrolled
      tracking.trackEvent('bottom_page_scrolled')
      @bottomPageScrolled = true
