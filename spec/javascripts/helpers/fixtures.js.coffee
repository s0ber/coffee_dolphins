window.$loadFixture = (name) ->
  $(window.__html__["spec/javascripts/fixtures/#{name}.ejs"])

window.loadFixture = (name) ->
  window.__html__["spec/javascripts/fixtures/#{name}.ejs"]
