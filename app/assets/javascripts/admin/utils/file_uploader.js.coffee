UPLOADER_TEMPLATE = '''
  <div class="uploader">
    <div class="uploader-button uploader-drop_area">
      <span class="uploader-button_inner">
        <span class="uploader-button_content">
          <span class="uploader-button_title">
            Перетащите картинку сюда, чтобы загрузить ее на сервер.
          </span>
        </span>
      </span>
    </div>

    <div class="uploader-button uploader-drop_button">
      <span class="uploader-button_inner">
        <span class="uploader-button_content">
          <span class="uploader-button_title">
            Перетащите картинку сюда, чтобы загрузить ее на сервер.
          </span>
        </span>
      </span>
    </div>
  </div>
'''

class Utils.FileUploader extends qq.FileUploaderBasic

  constructor: (options) ->
    qq.FileUploaderBasic.apply(@, arguments)

    $.extend @_options,
      multiple: false
      sizeLimit: 5 * 1024 * 1024
      allowedExtensions: 'jpg jpeg png gif'.split(' ')
      classes:
        button: 'uploader-drop_button'
        drop: 'uploader-drop_area'
        dropActive: 'is-active'
        area: 'layout'
      messages:
        typeError: 'Недопустимое расширение файла.'
        sizeError: 'Файл недопустимого размера.'
        emptyError: 'Файл не может быть пустым.'
        onLeave: 'Файл загружается на сервер. Загрузка прервется, если вы покините страницу.'
    , options

    @_classes = @_options.classes
    @el = @_options.element
    @$el = $(@el)

    @$el.html(UPLOADER_TEMPLATE)
    @_button = @_createUploadButton(@findByClass('button').get(0))

    @setupDragDrop()

  findByClass: (klass, item) ->
    @$el.find('.' + @_classes[klass])

  leavingDocumentOut: (e) ->
    if $.browser.mozilla
      not e.relatedTarget
    else
      e.clientX is 0 and e.clientY is 0

  contains: (el) ->
    (@el is el) or $.contains(@el, el)

  setupDragDrop: ->
    self = @
    dropArea = @findByClass('drop')
    element = self.el

    dz = new qq.UploadDropZone
      element: dropArea.get(0),

      onEnter: (e) ->
        dropArea.addClass(self._classes.dropActive)
        e.stopPropagation()

      onDrop: (e) ->
        dropArea.hide()
        dropArea.removeClass(self._classes.dropActive)
        self._uploadFileList(e.dataTransfer.files)

    dropArea.hide()

    qq.attach document, 'dragenter', (e) ->
      return if not dz._isValidFileDrag(e)
      dropArea.show()

    qq.attach document, 'dragleave', (e) ->
      dropArea.hide() if self.leavingDocumentOut(e)

    qq.attach element, 'dragleave', (e) ->
      return if not dz._isValidFileDrag(e)
      relatedTarget = document.elementFromPoint(e.clientX, e.clientY)

      return if self.contains(relatedTarget)

      dropArea.removeClass(self._classes.dropActive)

