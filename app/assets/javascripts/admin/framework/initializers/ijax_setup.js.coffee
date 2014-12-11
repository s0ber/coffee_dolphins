Ijax.configure
  onRequestResolve: (response, options) ->
    currentAssetsHash = gon.assetsMd5Hash
    newAssetsHash = options.assetsMd5Hash

    if newAssetsHash isnt currentAssetsHash
      location.href = options.path
      return false

window.ijax = new Ijax()
