# Forced disabling allows to disable link and then enable it only if force flag is provided.
# This helps to prevent unnecessary "enabling" of links.

# For example, we want to disable all remote links on before submit and enable it after submit.
# And we are specifying this as a default behavior for all remote links.
# But there are situations, when we don't want to enable the link on submit. We want to keep it
# disabled. In this case we should disable it manually with 'force' flag provided.

Utils.disableLink = ($link, force = false) ->
  $link.attr('disabled', 'disabled').addClass('is-disabled')
  $link.attr('data-force-disable', true) if force

Utils.enableLink = ($link, force = false) ->
  return if $link.attr('data-force-disable') and not force

  $link
    .removeClass('is-disabled')
    .removeAttr('disabled')
    .removeAttr('data-force-disable')

