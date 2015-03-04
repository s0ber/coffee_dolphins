class App.Views.Headline extends View

  els:
    title: '.js-headline-title'
    photos: '.js-headline-photos'
    description: '.js-headline-description'
    cta: '.js-headline-cta'

  initialize: ->
    if @transitionsSupported
      @$title
        .addClass('animate-show')
        .afterTransition =>
          @$photos.addClass('animate-show')
          setTimeout =>
            @$description.addClass('animate-show').afterTransition =>
              @$cta.addClass('animate-show')
          , 300
    else
      $('body').addClass('no-transitions')

  transitionsSupported: do ->
    fakediv = document.createElement('div')
    supported = false
    prefixes = 'ms Ms o O webkit Webkit moz Moz'.split(' ')

    for prefix in prefixes
      if fakediv.style[prefix + 'Transition']?
        supported = true
        break

    fakediv = null
    supported

