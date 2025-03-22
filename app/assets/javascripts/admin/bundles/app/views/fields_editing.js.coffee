class App.Views.FieldsEditing extends Dolphin.View
  els:
    fields: '@fields_editing-field'
    addNewFieldButton: '@fields_editing-new'
    fieldsContainer: '@fields_editing-container'
    emptyMessage: '@fields_editing-empty_message'

  events:
    'click @fields_editing-add': 'appendNewFieldForm'
    'click @fields_editing-remove': 'removeField'

  initialize: ->
    @applyBehavior('Sortable')
    @behaviors.Sortable.onSortUpdate @reorderFields.bind(@)

  appendNewFieldForm: ->
    $fieldForm = $(@fieldTemplate().html)

    $fieldForm.find('input, select, textarea').each (i, field) =>
      $field = $(field)
      name = $field.attr('name')
      $field
        .removeAttr('id')
        .attr(name: name.replace('0', @fieldsCounter()))

    @append(@$fieldsContainer(), $fieldForm)
    @toggleEmptyMessage()
    @behaviors.Sortable.resetSorting()

  removeField: (e) ->
    $fieldForm = $(e.currentTarget).closest('@fields_editing-field')
    $fieldForm.find('@fields_editing-destroy_field').val(1)
    $fieldForm.fadeOut => @toggleEmptyMessage()

  toggleEmptyMessage: ->
    @$emptyMessage().toggleClass(
      'hidden',
      @$fields().filter(':visible').length isnt 0
    )

  reorderFields: ->
    @$fields().each (i, field) ->
      $(field).find('@fields_editing-field_position').val(i)

  fieldTemplate: ->
    @$el.data('field-template')

  fieldsCounter: ->
    @$fields().length
