class App.Behaviors.Modals extends Dolphin.View

  els:
    modalsBg: '@modals-bg'
    modalsLayer: '@modals-layer'
    modalsContainer: '@modals-container'

  events:
    'click [data-modal]': 'loadModal'
    'click @close_modal': 'closeModal'

  initialize: ->
    @listen('modals:close_modal', @hideModal)

  loadModal: (e) ->
    $link = $(e.currentTarget)
    return if $link.hasClass('is-disabled')

    @showLoader($link)
    @createNewRequest(
      $.getJSON($link.data('modal'))
        .done @showModal.bind(@, $link)
        .always @hideLoader.bind(@, $link)
    )

  showModal: ($link, json) ->
    @$modal = @$renderTemplate('modal',
      title: json.title,
      html: json.html
    ).data('view-options', $modalSourceButton: $link)

    @showOverlay()
    @html(@$modalsContainer(), @$modal)

  closeModal: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @hideModal()

  hideModal: ->
    @$modal.remove()
    @$modal = null
    @hideOverlay()

# private

  showOverlay: ->
    @$el.css('overflowY', 'hidden')
    @$modalsBg().show()
    @$modalsLayer().show()
    @bindCloseEvents()

  hideOverlay: ->
    @unbindCloseEvents()
    @$modalsLayer().hide()
    @$modalsBg().hide()
    @$el.css('overflowY', 'auto')

  bindCloseEvents: ->
    @$el
      .on 'keyup.modals:hide', (e) =>
        @hideModal() if e.keyCode is 27

      .on 'click.modals:hide', (e) =>
        $clickedEl = $(e.target)
        $modal = $clickedEl.closest('[data-component="app#modal"]')
        @hideModal() unless $modal.is(@$modal)

  unbindCloseEvents: ->
    @$el.off('.modals:hide')

  showLoader: ($link) ->
    @utils.disableLink($link)
    @utils.showButtonLoader($link)

  hideLoader: ($link) ->
    @utils.enableLink($link)
    @utils.hideButtonLoader($link)

