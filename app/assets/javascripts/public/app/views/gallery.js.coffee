class App.Views.Gallery extends View

  els:
    prevButton: '.js-gallery-prev_button'
    nextButton: '.js-gallery-next_button'
    imageWrapper: '.js-gallery-image_wrap'
    imageTitle: '.js-gallery-image_title'
    imageNumber: '.js-gallery-current_image_number'

  initialize: ->
    @images = @$el.data('images')

    @currentIndex = 0

    @relocateModal()
    @preloadImages()

    @$prevButton.on('click', _.bind(@showPrevImage, @))
    @$nextButton.on('click', _.bind(@showNextImage, @))

  relocateModal: ->
    @$modal = @$el.closest('[data-view="app#modal"]')

    @$modal.css
      width: 'auto'
      display: 'inline-block'

    @pub 'relocate_modal'

  preloadImages: ->
    for image in @images
      $fakeImage = $("<img src=\"#{image.url}\" width=\"0\" height=\"0\" />").css(float: 'right')
      @$el.append($fakeImage)

  showPrevImage: ->
    return if @currentIndex is 0
    @currentIndex--

    @showImageByIndex(@currentIndex)

  showNextImage: ->
    return if @currentIndex is @images.length - 1
    @currentIndex++

    @showImageByIndex(@currentIndex)

  showImageByIndex: (index) ->
    image = @images[index]
    $image = $("<img src=\"#{image.url}\" width=\"#{image.width}\" height=\"#{image.height}\" />")

    @$imageWrapper.html($image)

    @$prevButton.toggleClass('g-dashed', @currentIndex isnt 0)
    @$nextButton.toggleClass('g-dashed', @currentIndex isnt @images.length - 1)

    @$imageNumber.text(@currentIndex + 1)
    @$imageTitle.text(image.alt)

    @pub 'relocate_modal'

