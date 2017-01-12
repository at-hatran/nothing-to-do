window.ENTER_KEY = 13
window.ESC_KEY = 27

window.Railsbackbone =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}

  init: ->
    console.log('init')
    new Railsbackbone.Routers.Tasks()
    Backbone.history.start()

$(document).ready ->
  Railsbackbone.init()
