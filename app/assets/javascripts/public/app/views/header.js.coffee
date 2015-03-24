class App.Views.Header extends View

  els:
    menuItems: '.js-top_menu-item'

  initialize: ->
    new App.Behaviors.Sticky($el: @$el) unless @$el.hasClass('js-fixed')
    @sub('menu_item_changed', @selectMenuItem)

  selectMenuItem: (sectionName) ->
    @$menuItems
      .removeClass('is-active')
      .filter("[data-section-name=#{sectionName}]")
        .addClass('is-active')

