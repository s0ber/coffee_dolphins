#= require_tree ./view_modules
#= require_self

class Dolphin.View extends Frames.View

  @include AjaxRequestsModule
  # @include AppDataModule
  @include DomHelpersModule
  @include NotificationsModule
  @include SelectorFunctionsModule
  # @include TemplatesRenderingModule

  @addToConfigureChain 'preconfigure'

  preconfigure: (@options = {}) ->
    @node = @options.node

  onUnload: ->
    @unload?()
    delete @node
    @remove()

  utils: Utils
