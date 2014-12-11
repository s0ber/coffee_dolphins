@TemplatesRenderingModule =

  renderTemplate: (templateName, locals={}) ->
    templateFn =
      if @componentName?
        @__templateComponentFn(templateName)
      else
        @__templateNamespaceFn(templateName)

    templateFn(locals)

  $renderTemplate: (args...) ->
    $(@renderTemplate(args...))

  __templateNamespaceFn: (templateName) ->
    JST["admin/bundles/#{@namespaceName.underscore()}/templates/#{templateName}"]

  __templateComponentFn: (templateName) ->
    JST["admin/bundles/#{@namespaceName.underscore()}/components/#{@componentName.underscore()}/templates/#{templateName}"]
