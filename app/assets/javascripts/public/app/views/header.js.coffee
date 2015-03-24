class App.Views.Header extends View

  els:
    menuItems: '.js-top_menu-item'

  initialize: ->
    new App.Behaviors.Sticky($el: @$el) unless @$el.hasClass('js-fixed')
    @sub('menu_item_changed', @selectMenuItem)

    @__trackNavigation()

  selectMenuItem: (sectionName) ->
    @$menuItems
      .removeClass('is-active')
      .filter("[data-section-name=#{sectionName}]")
        .addClass('is-active')

# private

  __trackNavigation: ->
    @$('[data-section-name]').on 'click', (e) ->
      # @trackEvent 'Навигация', 'Верхнее меню', $(e.currentTarget).data('section-name')

