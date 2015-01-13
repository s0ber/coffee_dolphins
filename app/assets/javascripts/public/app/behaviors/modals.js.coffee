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

    $link.addClass('is-disabled')

    $.getJSON($link.data('modal'))
      .done((json) => @showModal($link, json))
      .always(=> $link.removeClass('is-disabled'))

  showModal: ($link, json) ->
    @$modal = $(@renderModal(json.title, json.html)).data('view-options', $modalSourceButton: $link)

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

  renderModal: (title, html) ->
    """
    <div class="modal" data-view="app#modal">
      <div class="modal-header">
        #{title}
        <div class="fl_r">
          <div class="modal-close js-close_modal">
            <i class="fa fa-close"></i>
          </div>
        </div>
      </div>
      <div class="modal-body">#{html}</div>
    </div>
    """

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
