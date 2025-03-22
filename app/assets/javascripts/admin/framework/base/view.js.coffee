#= require_tree ./view_modules
#= require_self

VIEW_INSTANCE_OPTIONS = ['namespaceName', 'componentName', 'componentId', 'node']

class Dolphin.View extends Frames.View

  @include AjaxRequestsModule
  @include AppDataModule
  @include BehaviorModule
  @include DomHelpersModule
  @include NotificationsModule
  @include SelectorFunctionsModule
  @include TemplatesRenderingModule

  @addToConfigureChain 'preconfigure'

  preconfigure: (@options = {}) ->
    # copy some options to view instance
    _.extend(@, Object.select(options, VIEW_INSTANCE_OPTIONS))

    # extends options with options from element's "data-view-options"
    _.extend(@options, $(@options.el).data('view-options'))

  onUnload: ->
    @unload?()
    @unsubscribe()
    delete @node
    @remove()

  utils: Utils

  # it at first calls provided callback,
  # and then observes provided model's 'change' event with this callback
  observe: (viewModel, callback) ->
    callback.call(@)
    @listenTo(viewModel, 'change', callback)
