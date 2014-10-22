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

App.Utils.showButtonLoader = ($button) ->
  unless $button.hasClass('has-loader')
    $loader = $(LOADER_TEMPLATE)

    $button
      .wrapInner('<div class="small_button-wrap" />')
      .append($loader)
      .addClass('has-loader')

  $button
    .attr('disabled', 'disabled')
    .addClass('is-loading')

App.Utils.hideButtonLoader = ($button) ->
  return unless $button.hasClass('has-loader')

  $button
    .removeClass('is-processed')
    .removeAttr('disabled')
