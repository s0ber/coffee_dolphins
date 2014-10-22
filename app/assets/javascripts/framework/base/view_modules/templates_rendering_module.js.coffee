BASE_BUNDLES_PATH = 'platform/bundles'
EXPLICIT_NAMESPACE_PATTERN = /(.+)#(.+)/

@TemplatesRenderingModule =

  renderTemplate: (templateName, locals={}) ->
    # we can specify namespace for template explicitely before # sign
    # e.g.: @renderTemplate('modals#secret')
    if EXPLICIT_NAMESPACE_PATTERN.test(templateName)
      [__, explicitNamespace, templateName] = templateName.match(EXPLICIT_NAMESPACE_PATTERN)

    templateFn =
      if explicitNamespace?
        @__templateNamespaceFn(explicitNamespace, templateName)
      else if @componentName?
        @__templateComponentFn(templateName)
      else
        @__templateNamespaceFn(@namespaceName.underscore(), templateName)

    # try to render from shared namespace, if haven't found a template
    templateFn ?= @templateSharedFn(templateName)

    templateFn(locals)

  $renderTemplate: (args...) ->
    $(@renderTemplate(args...))

  templateSharedFn: (templateName) ->
    @__templateNamespaceFn('shared', templateName)

  __templateNamespaceFn: (namespaceName, templateName) ->
    JST["#{BASE_BUNDLES_PATH}/#{namespaceName}/templates/#{templateName}"]

  __templateComponentFn: (name) ->
    JST["#{BASE_BUNDLES_PATH}/#{@namespaceName.underscore()}/components/#{@componentName.underscore()}/templates/#{name}"]
