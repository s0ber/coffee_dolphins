describe 'App.Views.Layout', ->
  before ->
    @view = new App.Views.Layout()

  describe '#constructor', ->
    it 'is example spec', ->
      expect(@view.constructor).to.match(/Layout/)
