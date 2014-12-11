class App.Behaviors.Dynamic extends Dolphin.View

  initialize: ->
    unless @blockPath()?
      throw new Error('"Dynamic" behavior is initialized, but block path for it is not specified.')

  redraw: ->
    $.getJSON(@blockPath()).done (json) => @updateHtml(json.html)

# private

  blockPath: ->
    @$el.data('block-path')

