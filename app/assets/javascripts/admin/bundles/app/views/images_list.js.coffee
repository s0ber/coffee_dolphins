class App.Views.ImagesList extends Dolphin.View

  els:
    uploader: '@images_list-uploader'

  initialize: ->
    @initFileUploader()

  initFileUploader: ->
    new Utils.FileUploader
      element: @$uploader()[0]
      action: @uploadPath()
      params:
        landing_id: @landingId()
      onComplete: (id, fileName, data) =>
        console.log data

# getters

  landingId: ->
    @$el.data('landing-id')

  uploadPath: ->
    @$el.data('upload-image-path')

