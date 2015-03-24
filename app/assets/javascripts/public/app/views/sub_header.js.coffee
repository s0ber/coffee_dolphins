class App.Views.SubHeader extends View

  initialize: ->
    @sub('menu_item_changed', @toggleSubHeader)

  toggleSubHeader: (sectionName) ->
    if sectionName is 'main'
      @$el.fadeOut(200) if @$el.is(':visible')
    else if @$el.is(':hidden')
      @$el.fadeIn(200)

