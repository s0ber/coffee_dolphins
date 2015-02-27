Ijax.configure
  onRequestResolve: (response, options) ->
    currentAssetsHash = gon.assetsMd5Hash
    newAssetsHash = options.assetsMd5Hash

    if newAssetsHash isnt currentAssetsHash
      location.href = options.path
      return false

  onResponseFail: (path) ->
    Dolphin.broker.publish('flash_message:alert', path)

window.ijax = new Ijax()
