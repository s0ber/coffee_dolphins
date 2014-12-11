class App.Views.PhotosSlider extends View

  els:
    mainPhoto: '.js-main_photo'
    previews: '.js-photo_preview'
    prevArrow: '.js-show_prev_photo'
    nextArrow: '.js-show_next_photo'

  initialize: ->
    @previewsNum = @$previews.length

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

# private

  $activePreview: ->
    @$previews.filter('.is-active')
