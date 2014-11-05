class App.Behaviors.Modals extends Dolphin.View

  els:
    modalsBg: '@modals-bg'
    modalsLayer: '@modals-layer'
    modalsContainer: '@modals-container'

  events:
    'click [data-modal]': 'loadModal'
    'click @close_modal': 'closeModal'

  loadModal: (e) ->
    $link = $(e.currentTarget)
    return if $link.hasClass('is-disabled')

    @showLoader($link)
    @createNewRequest(
      $.getJSON($link.data('modal'))
        .done @showModal.bind(@)
        .always @hideLoader.bind(@, $link)
    )

  showModal: (json) ->
    @$modal = @$renderTemplate('modal', title: json.title, html: json.html)
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
        $modal = $clickedEl.closest('[data-view="app#modal"]')
        @hideModal() unless $modal.is(@$modal)

  unbindCloseEvents: ->
    @$el.off('.modals:hide')

  showLoader: ($link) ->
    @utils.showButtonLoader($link)

  hideLoader: ($link) ->
    @utils.hideButtonLoader($link)

