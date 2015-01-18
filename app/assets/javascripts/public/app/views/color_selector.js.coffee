class App.Views.ColorSelector extends View

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

    $('link[rel="stylesheet"]').attr(href: "/assets/public/color_schemes/#{color}.css?body=1")

    $('img').each (i, img) ->
      $img = $(img)
      src = $img.attr('src')

      if /images\/public\/icons/.test(src)
        $(img).attr(src: src.replace(''))
