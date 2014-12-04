class App.Views.LikeButton extends Dolphin.View

  events:
    'click': 'toggleLike'

  toggleLike: (e) ->
    return if @$el.hasClass('is-disabled')

    @utils.disableLink(@$el)

    requestPath =
      if @$el.hasClass('is-liked')
        @$el.data('unlike-path')
      else
        @$el.data('like-path')

    $.post(requestPath, _method: 'put').done (json) =>
      @utils.enableLink(@$el)
      @$el.toggleClass('is-liked')
      @showNotice(json.notice) if json.notice

