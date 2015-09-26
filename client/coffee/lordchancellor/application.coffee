define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  #Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'
  require 'bootstrap'
  
  handles = ft.misc.mainhandles
  
  AppModel = require 'appmodel'

  
  MainChannel = Backbone.Wreqr.radio.channel 'global'

  MainChannel.reqres.setHandler 'main:app:appmodel', ->
    #console.log "setHandler main:app:appmodel"
    AppModel
  


  set_get_current_user_handler = ft.models.base.set_get_current_user_handler
  
  current_user_url = '/rest/v0/main/current/user'
  set_get_current_user_handler MainChannel, current_user_url
      
  
  handles.set_mainpage_init_handler()
  handles.set_main_navbar_handler()

  #layout = Views.BootstrapNoGridLayout
  #navbar = Views.BootstrapNavBarView
  #MainPage.set_init_page_handler MainBus, 'nogridpage', layout, navbar

  
  require 'useradmin/main'
  require 'sitetext/main'
  require 'frontdoor/main'
  
  app = new Marionette.Application()
  # attach app to window
  window.App = app

  app.ready = false

  
  user = MainChannel.reqres.request 'main:app:current-user'
  response = user.fetch()
  response.done ->
    handles.prepare_app app, AppModel
    app.ready = true

  
  module.exports = app
  
    
