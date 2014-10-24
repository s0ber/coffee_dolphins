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
  # @include TemplatesRenderingModule

  @addToConfigureChain 'preconfigure'

  preconfigure: (@options = {}) ->
    # copy some options to view instance
    _.extend(@, Object.select(options, VIEW_INSTANCE_OPTIONS))

  onUnload: ->
    @unload?()
    delete @node
    @remove()

  utils: Utils
