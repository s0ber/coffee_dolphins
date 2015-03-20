class App.Behaviors.Modals extends View

  els:
    modalsBg: '.js-modals-bg'
    modalsLayer: '.js-modals-layer'
    modalsContainer: '.js-modals-container'

  initialize: ->
    @$el.on('click', '[data-modal]', _.bind(@loadModal, @))
    @$el.on('click', '[data-inline-modal]', _.bind(@showInlineModal, @))
    @$el.on('click', '.js-close_modal', _.bind(@closeModal, @))

    @sub('load_modal', @loadModalByPath)

  loadModal: (e) ->
    $link = $(e.currentTarget)
    return if $link.hasClass('is-disabled')

    $link.addClass('is-disabled')

    path = $link.data('modal')
    $.getJSON($link.data('modal'))
      .done((json) =>
        @__trackModalShow(path)
        @showModal(json)
      )
      .always(=> $link.removeClass('is-disabled'))

  loadModalByPath: (path, allowToClose = true) ->
    $.getJSON(path).done (json) => @showModal(json, allowToClose)

  showInlineModal: (e) ->
    modalId = $(e.currentTarget).data('inline-modal')
    $modalTemplate = $("##{modalId}")

    @showModal(title: $modalTemplate.data('title'), html: $modalTemplate.html())

  showModal: (options, allowToClose = true) ->
    @$modal = $(@renderModal(options.title, options.html))

    @showOverlay()
    @bindCloseEvents() if allowToClose is true
    @html(@$modalsContainer, @$modal)

  closeModal: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @hideModal()

  hideModal: ->
    @$modal?.remove()
    @$modal = null

    @unbindCloseEvents()
    @hideOverlay()

  renderModal: (title, html) ->
    if title?
      """
      <div class="modal" data-view="app#modal">
        <div class="modal-header">
          #{title}
          <div class="modal-close js-close_modal">
            <i class="fa fa-close"></i>
          </div>
        </div>
        <div class="modal-body">#{html}</div>
      </div>
      """
    else
      """
      <div class="modal has-no_header" data-view="app#modal">
        <div class="modal-body">#{html}</div>
      </div>
      """

# private

  showOverlay: ->
    @$el.css('overflowY', 'hidden')
    @$modalsBg.show()
    @$modalsLayer.show()

  hideOverlay: ->
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

  __trackModalShow: (modalPath) ->
    gaWidget.trackEvent 'Модальные окна', 'Просмотр', modalPath
