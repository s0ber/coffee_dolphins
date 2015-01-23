class App.Behaviors.Autofocus extends View

  initialize: ->
    @sub('menu_item_changed', @focusPhoneField)

  focusPhoneField: (sectionName) ->
    return unless sectionName is 'main'
    @$sectionByName('main').autofocus()

  $sections: ->
    @_$sections ?= $('[data-section]')

  $sectionByName: (name) ->
    @$sections().filter("[data-section='#{name}']")

