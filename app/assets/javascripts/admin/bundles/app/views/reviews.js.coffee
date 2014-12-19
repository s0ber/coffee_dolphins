class App.Views.Reviews extends Dolphin.View

  els:
    reviewsContainer: '@reviews-container'
    reviews: '@reviews-review'
    emptyMessage: '@reviews-empty_message'

  events:
    'click @reviews-add': 'addReview'

  initialize: ->
    @reviewsCounter = @$reviews().length

  addReview: ->
    @$emptyMessage().hide()
    @reviewsCounter++

    $review = $(@reviewTemplate().html)
    $review.find('input, textarea').each (i, field) =>
      $field = $(field)
      name = $(field).attr('name')
      $(field)
        .removeAttr('id')
        .attr(name: name.replace('0', @reviewsCounter))

    @append(@$reviewsContainer(), $review)

# getter

  reviewTemplate: ->
    @$el.data('review-template')
