class App.Views.ImagesList extends Dolphin.View

  els:
    uploader: '@images_list-uploader'
    imagesContainer: '@images_list-container'
    images: '@images_list-image'

  initialize: ->
    @initFileUploader()
    @applyBehavior('Sortable')
    @behaviors.Sortable.onSortUpdate @reorderImages.bind(@)

  initFileUploader: ->
    new Utils.FileUploader
      element: @$uploader()[0]
      action: @uploadPath()
      params:
        authenticity_token: $('meta[name="csrf-token"]').attr('content')
        landing_id: @landingId()
      onComplete: (id, fileName, json) =>
        @addImage(json)
        @showNotice(json.notice) if json.notice?

  addImage: (json) ->
    $image = $(@imageTemplate().html)

    $image.find('input, textarea').each (i, field) =>
      $field = $(field)
      name = $(field).attr('name')

      $(field)
        .removeAttr('id')
        .attr(name: name.replace('0', @imagesCounter()))

    $image
      .attr('data-id': json.image.id)
      .find('@images_list-image_tag')
        .attr(src: json.image.path)
        .end()
      .find('@images_list-image_id')
        .val(json.image.id)
        .end()
      .find('@images_list-image_uniq_id')
        .text(json.image.id)

    @append(@$imagesContainer(), $image)
    $image.autofocus()

    @incrementImagesCounter()
    @behaviors.Sortable.resetSorting()

# getters

  imagesCounter: ->
    @_imagesCounter ?= @$images().length

  landingId: ->
    @$el.data('landing-id')

  uploadPath: ->
    @$el.data('upload-image-path')

  imageTemplate: ->
    @$el.data('image-template')

# setters

  incrementImagesCounter: ->
    @_imagesCounter++

  reorderImages: ->
    return unless @reorderPath()

    $images = @$images()

    indexes = for i in [0...$images.length]
      $images.eq(i).data('id')

    $.post(@reorderPath(), _method: 'put', indexes: indexes).done (json) =>
      @showNotice(json.notice) if json.notice

  reorderPath: ->
    @$el.data('reorder-path')
