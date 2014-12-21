class App.Views.PhotosSlider extends View

  els:
    mainPhoto: '.js-main_photo'
    previews: '.js-photo_preview'
    prevArrow: '.js-show_prev_photo'
    nextArrow: '.js-show_next_photo'
    previewsContainer: '.js-photos_previews_container'

  initialize: ->
    @previewsNum = @$previews.length
    @photosRange = [0..3]

    @$previews.first().addClass('is-active')

    @$previews.on('click', _.bind(@selectPhoto, @))
    @$prevArrow.on('click', _.bind(@selectPrevPhoto, @))
    @$nextArrow.on('click', _.bind(@selectNextPhoto, @))

    @switchPhotosByInterval()

  selectPrevPhoto: (e) ->
    prevPhotoIndex = (@$activePreview().index() - 1) % @previewsNum
    @selectPhotoByIndex(prevPhotoIndex)

  selectNextPhoto: (e) ->
    nextPhotoIndex = (@$activePreview().index() + 1) % @previewsNum
    @selectPhotoByIndex(nextPhotoIndex)

  selectPhoto: (e) ->
    $preview = $(e.currentTarget)
    return if $preview.hasClass('is-active')

    previewIndex = $preview.index()
    @selectPhotoByIndex(previewIndex)

  selectPhotoByIndex: (index) ->
    unless index in @photosRange
      @adjustPhotosRangeToIndex(index)

    $preview = @$previews.eq(index)
    imagePath = $preview.find('img').attr('src')

    @$previews.removeClass('is-active')
    $preview.addClass('is-active')

    @$mainPhoto
      .hide()
      .css('background-image': "url(#{imagePath})")
      .fadeIn()

    @switchPhotosByInterval()

  switchPhotosByInterval: ->
    clearInterval(@photosInterval) if @photosInterval?
    @photosInterval = setInterval(=>
      @selectNextPhoto() if Utils.isElementInViewport(@$mainPhoto)
    , 4000)

  adjustPhotosRangeToIndex: (index) ->
    if index >= 0
      if index < @photosRange[0]
        @photosRange = [index..index+3]
      else
        @photosRange = [index-3..index]
    else
      @photosRange = [@previewsNum+index-3..@previewsNum+index]

    offsetIndex = @photosRange[0]
    @$previewsContainer.css('margin-left': - offsetIndex * @previewWidth())

# private

  previewWidth: ->
    @$previews.eq(-1).outerWidth(true)

  $activePreview: ->
    @$previews.filter('.is-active')
