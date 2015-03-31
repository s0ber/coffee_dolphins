class App.Views.PhotosSlider extends View

  els:
    mainPhoto: '.js-main_photo'
    previews: '.js-photo_preview'
    prevArrow: '.js-show_prev_photo'
    nextArrow: '.js-show_next_photo'
    previewsContainer: '.js-photos_previews_container'

  initialize: ->
    @photos = @$el.data('photos')
    @photosNum = @photos.length
    @photosRange = [0..3]

    @activePhotoIndex = 0
    @$previews.first().addClass('is-active')

    @$previews.on('click', _.bind(@selectPhoto, @))
    @$prevArrow.on('click', _.bind(@selectPrevPhoto, @))
    @$nextArrow.on('click', _.bind(@selectNextPhoto, @))

    @switchPhotosByInterval()

    setTimeout(_.bind(@preloadPhotos, @), 100)

  selectPrevPhoto: (e) ->
    prevPhotoIndex = (@activePhotoIndex - 1) % @photosNum
    @selectPhotoByIndex(prevPhotoIndex)

  selectNextPhoto: (e) ->
    nextPhotoIndex = (@activePhotoIndex + 1) % @photosNum
    @selectPhotoByIndex(nextPhotoIndex)

  selectPhoto: (e) ->
    $preview = $(e.currentTarget)
    return if $preview.hasClass('is-active')

    previewIndex = $preview.index()
    @selectPhotoByIndex(previewIndex)

  selectPhotoByIndex: (index) ->
    index = (@photosNum + index) if index < 0
    @activePhotoIndex = index

    unless index in @photosRange
      @adjustPhotosRangeToIndex(index)

    $preview = @$previews.eq(index)

    imagePath = @photos[index]

    @$previews.removeClass('is-active')
    $preview.addClass('is-active')

    @$mainPhoto
      .addClass('is-hidden')
      .afterTransition =>
        @$mainPhoto
          .css('background-image': "url(#{imagePath})")
          .removeClass('is-hidden')

    @switchPhotosByInterval()

  switchPhotosByInterval: ->
    clearInterval(@photosInterval) if @photosInterval?
    @photosInterval = setInterval(=>
      isModalOpened = $('[data-view="app#modal"]:visible').length > 0
      return if isModalOpened
      @selectNextPhoto() if Utils.isElementInViewport(@$mainPhoto)
    , 2000)

  adjustPhotosRangeToIndex: (index) ->
    if index >= 0
      if index < @photosRange[0]
        @photosRange = [index..index+3]
      else
        @photosRange = [index-3..index]
    else
      @photosRange = [@photosNum+index-3..@photosNum+index]

    offsetIndex = @photosRange[0]
    @$previewsContainer.css('margin-left': - offsetIndex * @previewWidth())

  preloadPhotos: ->
    for photo in @photos
      $fakePhoto = $("<img src=\"#{photo}\" width=\"0\" height=\"0\" />")
      @$el.append($fakePhoto)

# private

  previewWidth: ->
    @$previews.eq(-1).outerWidth(true)

