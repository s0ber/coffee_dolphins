class App.Views.Keywords extends Dolphin.View

  els:
    field: 'input[type="text"]:first'
    keywordsContainer: '@keywords-container'

  events:
    'keypress input[type="text"]': 'processKeypress'
    'keyup input[type="text"]': 'addKeywordOnEnter'
    'blur input[type="text"]': 'addKeywordOnBlur'
    'click @keyword-delete': 'deleteKeyword'

  initialize: ->
    @renderKeywordsContainer()

    @keywordsList = new App.ViewModels.KeywordsList()

    @listenTo(@keywordsList, 'items_reset', @renderInitialKeywords)
    @listenTo(@keywordsList, 'item_added',  @addKeyword)

    @keywordsList.reset(@associatedAttributesCollection())

  renderKeywordsContainer: ->
    $container = $('<div class="tags has-mt7" data-role="keywords-container" />')
    @append(@$el, $container)

  renderInitialKeywords: (keywords) ->
    @$keywordsContainer().html(
      keywords.map((keyword) =>
        @renderKeyword(keyword)
      ).join('')
    )

  addKeyword: (keyword) ->
    $keyword = $(@renderKeyword(keyword)).hide()
    $keyword.appendTo(@$keywordsContainer()).fadeIn()

  addKeywordOnEnter: (e) ->
    return unless e.keyCode is 13

    e.preventDefault()
    e.stopPropagation()

    keyword = $(e.currentTarget).val()
    return false if not keyword or @isKeywordCached(keyword)

    @$field().val('')
    @keywordsList.add(name: keyword)

  addKeywordOnBlur: (e) ->
    return if @$field().val().isBlank()

    keyword = @$field().val()
    unless @isKeywordCached(keyword)
      @keywordsList.add(name: keyword)

    @$field().val('')

  renderKeyword: (keyword) ->
    keywordsHtml = @renderTemplate @templateName(),
      objectName: @objectName()
      associatedAttributesName: @associatedAttributesName()
      keyword: keyword

    keywordsHtml

  deleteKeyword: (e) ->
    $keyword = $(e.currentTarget).closest('@keyword')
    keyword = _.unescape($keyword.data('name'))

    @keywordsList.removeByName(keyword)
    $keyword
      .find('@keyword-destroy_flag').val(1).end()
      .fadeOut('fast')

  processKeypress: (e) ->
    if e.keyCode is 13
      unless @$field().val().isBlank()
        e.preventDefault()
        e.stopPropagation()
      else
        # if field is blank, we are submitting form and moving to the next one
        # @$nextField().focus()
      return

    newVal = @utils.getNewFieldVal(e)
    return unless newVal?

    keypressChar = @utils.getChar(e)

    if keypressChar is ','
      [newKeyword, newFieldVal] = newVal.split(',').map('trim')

      if not newKeyword.isBlank() and not @isKeywordCached(newKeyword)
        @keywordsList.add(name: newKeyword)

      # let event propagate and then set field val
      (=>
        @$field().val(newFieldVal)
      ).delay(0)

# getters

  $nextField: ->
    $keywordsViews = $('[data-view="app#keywords"]')
    curFieldIndex = $keywordsViews.toArray().indexOf(this.el)
    $keywordsViews.eq(curFieldIndex + 1).find('input[type="text"]')

  objectName: ->
    @_objectName ?= @$field().data('object-name')

  associatedAttributesName: ->
    @_associatedAttributesName ?= @$field().data('associated-attributes-name')

  associatedAttributesCollection: ->
    @_associatedAttributesCollection ?= @$field().data('associated-attributes-collection') or []

  templateName: ->
    @_templateName ?= @$field().data('template-name')

# private

  isKeywordCached: (keywordName) ->
    @keywordsList.hasItemWithName(keywordName)

