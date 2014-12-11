class App.Behaviors.Modals extends View

  els:
    modalsBg: '.js-modals-bg'
    modalsLayer: '.js-modals-layer'
    modalsContainer: '.js-modals-container'

  events:
    'click [data-modal]': 'loadModal'
    'click .js-close_modal': 'closeModal'

  initialize: ->
    @$el.on('click', '[data-modal]', _.bind(@loadModal, @))
    @$el.on('click', '.js-close_modal', _.bind(@closeModal, @))

  loadModal: (e) ->
    $link = $(e.currentTarget)
    return if $link.hasClass('is-disabled')

    # @createNewRequest(
    #   $.getJSON($link.data('modal')).done @showModal.bind(@, $link)
    # )

    @showModal($link)

  showModal: ($link, json) ->
    # @$modal = @$renderTemplate('modal',
    #   title: json.title,
    #   html: json.html
    # ).data('view-options', $modalSourceButton: $link)
    #
    @$modal = $($('#modal_template').data('html'))

    @showOverlay()
    @html(@$modalsContainer, @$modal)

  closeModal: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @hideModal()

  hideModal: ->
    @$modal?.remove()
    @$modal = null
    @hideOverlay()

# private

  showOverlay: ->
    @$el.css('overflowY', 'hidden')
    @$modalsBg.show()
    @$modalsLayer.show()
    @bindCloseEvents()

  hideOverlay: ->
    @unbindCloseEvents()
    @$modalsLayer.hide()
    @$modalsBg.hide()
    @$el.css('overflowY', 'auto')

  bindCloseEvents: ->
    @$el
      .on 'keyup.modals:hide', (e) =>
        @hideModal() if e.keyCode is 27

      .on 'click.modals:hide', (e) =>
        $clickedEl = $(e.target)
        $modal = $clickedEl.closest('[data-view="app#modal"]')
        @hideModal() unless $modal.is(@$modal)

  unbindCloseEvents: ->
    @$el.off('.modals:hide')
