class App.Views.PhoneModal extends View

  initialize: ->
    @$modal = @$el.closest('[data-view="app#modal"]')
    @$modal.addClass('is-inline is-centered')

    @pub 'relocate_modal'
