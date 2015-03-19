class App.Views.Reviews extends View

  els:
    leftArrow: '.js-reviews-arrow_left'
    rightArrow: '.js-reviews-arrow_right'
    reviews: '.js-reviews-item'

  initialize: ->
    @reviewsNum = @$reviews.length

    @$leftArrow.on('click', _.bind(@showPrevReview, @))
    @$rightArrow.on('click', _.bind(@showNextReview, @))

    @adjustReviewsHeightToMaxHeightReview()

  $activeReview: ->
    @$reviews.filter('.is-active')

  showPrevReview: ->
    prevReviewIndex = (@$activeReview().index() - 1) % @reviewsNum
    @showReviewByIndex(prevReviewIndex)

  showNextReview: ->
    nextReviewIndex = (@$activeReview().index() + 1) % @reviewsNum
    @showReviewByIndex(nextReviewIndex)

  showReviewByIndex: (index) ->
    @$reviews
      .removeClass('is-active').hide()
      .eq(index)
        .addClass('is-active').fadeIn('slow')

  adjustReviewsHeightToMaxHeightReview: ->
    maxHeight = 0
    $maxHeightReview = null

    @$reviews.each (i, review) ->
      $review = $(review)
      if (height = $review.height()) > maxHeight
        maxHeight = height
        $maxHeightReview = $review

    textHeight = maxHeight - @$reviews.first().find('.js-reviews-item_info').outerHeight(true)
    @$el.css(height: maxHeight, lineHeight: maxHeight + 'px')

    @$leftArrow
      .add(@$rightArrow)
      .css(height: textHeight, lineHeight: textHeight + 'px')

