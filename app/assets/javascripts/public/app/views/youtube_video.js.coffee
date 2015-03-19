class App.Views.YoutubeVideo extends View

  initialize: ->
    @$video = @$('iframe')
    @aspectRatio = @$video.attr('height') / @$video.attr('width')

    @$video.removeAttr('width').removeAttr('height')

    @resizeVideo()
    $(window).on 'resize', _.debounce(_.bind(@resizeVideo, @), 50)

  resizeVideo: ->
    elWidth = @$el.width()
    @$video.attr
      width: elWidth
      height: elWidth * @aspectRatio
