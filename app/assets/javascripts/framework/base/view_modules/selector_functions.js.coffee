@SelectorFunctionsModule =

  included: (klass) ->
    klass.addToConfigureChain('__createSelectors')

  # Create selector functions.
  __createSelectors: ->
    @__createSelector(name, selector) for name, selector of @els

  # Create selector function.
  __createSelector: (name, selector) ->
    cachedMatches = selector.match(/^cached (.+)/)
    @['$' + name] = @__selectorFn(cachedMatches, name, selector)

  # Remove all selector functions from instance.
  __removeSelectors: ->
    @__removeSelector(name, selector) for name, selector of @els

  # Remove selector by name.
  __removeSelector: (name, selector) ->
    cachedMatches = selector.match(/^cached (.+)/)
    delete @['$_' + name] if cachedMatches
    delete @['$' + name]


  # private

  # Selector function factory. Returns new selector functon binded to instance.
  __selectorFn: (cachedMatches, name, selector) ->
    =>
      # If @el defined for instance.
      if @el
        if cachedMatches
          # If function should cache jQuery object, return cached object or perform selector.
          @['$_' + name] ||= @$(cachedMatches[1])
        else
          # Otherwise perform selector.
          @$(selector)
      else
        $()
