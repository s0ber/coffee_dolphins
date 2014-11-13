LOADER_TEMPLATE = '''
  <div class="button_loader">
    <div class="button_loader-item is-1"></div>
    <div class="button_loader-item is-2"></div>
    <div class="button_loader-item is-3"></div>
    <div class="button_loader-item is-4"></div>
    <div class="button_loader-item is-5"></div>
    <div class="button_loader-item is-6"></div>
    <div class="button_loader-item is-7"></div>
    <div class="button_loader-item is-8"></div>
  </div>
'''

Utils.showButtonLoader = ($button) ->
  return if $button.hasClass('is-icon')
  unless $button.hasClass('has-loader')
    $loader = $(LOADER_TEMPLATE)

    $button
      .wrapInner('<div class="small_button-wrap" />')
      .append($loader)
      .addClass('has-loader')

  $button
    .attr('disabled', 'disabled')
    .addClass('is-loading is-disabled')

Utils.hideButtonLoader = ($button) ->
  return if $button.hasClass('is-icon')
  return if not $button.hasClass('has-loader') or not $button.hasClass('is-loading')

  $button
    .removeClass('is-loading is-disabled')
    .removeAttr('disabled')
    # this is a button forced "repaint"
    .hide().show(0)
