class App.Views.ColorSelector extends View

  ICONS_IMAGES_PATTERN = /assets\/public\/icons\/(\w+)\/\w+.png/

  els:
    colors: '.js-color_selector-color'

  initialize: ->
    @$colors.on('click', _.bind(@selectColor, @))

  selectColor: (e) ->
    $color = $(e.currentTarget)
    color = $color.data('color')

    $color
      .siblings().removeClass('is-active').end()
      .addClass('is-active')

    if gon.env is 'development'
      $('link[rel="stylesheet"]').attr(href: "/assets/public/color_schemes/#{color}.css?body=1")
    else if gon.env is 'production'
      $('link[rel="stylesheet"]').attr(href: '/assets' + gon["#{color}_color_scheme"])

    $('img').each (i, img) ->
      $img = $(img)
      src = $img.attr('src')

      newSrc = src.replace ICONS_IMAGES_PATTERN, (string, oldColor) ->
        string.replace(oldColor, color)

      $(img).attr(src: newSrc)
