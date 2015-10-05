define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
 
  #Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'
  require 'bootstrap'
  
  handles = ft.misc.mainhandles
  
  #AppModel = require 'appmodel'

    
  MainChannel = Backbone.Wreqr.radio.channel 'global'

  require 'models'

  #MainChannel.reqres.setHandler 'main:app:appmodel', ->
    #console.log "setHandler main:app:appmodel"
    #AppModel
  


  set_get_current_user_handler = ft.models.base.set_get_current_user_handler
  
  current_user_url = '/rest/v0/main/current/user'
  set_get_current_user_handler MainChannel, current_user_url
      
  set_get_current_appmodel_handler = ft.models.base.set_get_current_appmodel_handler
  appmodel_url = "/rest/v0/main/webobjects/main/7?content="
  set_get_current_appmodel_handler MainChannel, appmodel_url
  
  handles.set_mainpage_init_handler()
  handles.set_main_navbar_handler()

  # require applets
  require 'frontdoor/main'
  require 'wiki/main'
  require 'bumblr/main'
  require 'hubby/main'
  require 'github/main'
  require 'gitannex/main'
  require 'vtdendro/main'
      
  app = new Marionette.Application()
  # attach app to window
  window.App = app
  window.app = app

  AppModel = MainChannel.reqres.request 'main:app:appmodel'
  response = AppModel.fetch()
  response.done ->
    console.log "got appmodel"
    user = MainChannel.reqres.request 'main:app:current-user'
    response = user.fetch()
    response.done =>
      console.log "got user", AppModel
      handles.prepare_app app, AppModel
      app.start()

  
  module.exports = app
  
    
