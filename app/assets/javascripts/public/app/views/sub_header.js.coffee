class App.Views.SubHeader extends View

  initialize: ->
    @sub('menu_item_changed', @toggleSubHeader)

    @__trackBuyButtonNavigation()

  toggleSubHeader: (sectionName) ->
    if sectionName is 'main'
      @$el.fadeOut(200) if @$el.is(':visible')
    else if @$el.is(':hidden')
      @$el.fadeIn(200)

# private

  __trackBuyButtonNavigation: ->
    $('.js-sub_header-buy').on 'click', ->
      gaWidget.trackEvent 'Навигация', 'Сабхедер'
