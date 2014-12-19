class App.Views.EditableHtml extends Dolphin.View

  initialize: ->
    @initializeCodemirror()

  initializeCodemirror: ->
    @codemirror = CodeMirror.fromTextArea @el,
      mode: 'text/html'
      lineWrapping: true
      lineNumbers: true
      autoCloseBrackets: true
      matchBrackets: true
      autoCloseTags: true
      matchTags: {bothTags: true}

    @codemirror.on('change', @updateTextarea.bind(@))

  updateTextarea: (->
    @codemirror.save()
  ).debounce(200)

