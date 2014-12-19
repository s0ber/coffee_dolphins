class App.Views.Textarea extends Dolphin.View

  initialize: ->
    @$el.find('textarea')
      .autosize()
      .on('keypress', @submitByCtrlEnter.bind(@))

  submitByCtrlEnter: (e) ->
    isCtrlEnter = e.ctrlKey and e.keyCode is 13

    if isCtrlEnter
      e.preventDefault()
      @$el.closest('form').submit()

