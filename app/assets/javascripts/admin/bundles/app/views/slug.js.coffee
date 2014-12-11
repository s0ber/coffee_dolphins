class App.Views.Slug extends Dolphin.View

  els:
    field: 'input[type="text"]'

  events:
    'change input[type="text"]': 'updateSlug'

  updateSlug: ->
    slugVal = @$field().val().replace(/\W+/g, '-').replace(/(^\W+|\W+$)/g, '').toLowerCase()
    @$field().val(slugVal)

