define (require, exports, module) ->
  $ = require 'jquery'
  jQuery = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  bootstrap = require 'bootstrap'
  Marionette = require 'marionette'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'

  handles = ft.misc.mainhandles
  
  AppModel = require 'appmodel'

  
  MainChannel = Backbone.Wreqr.radio.channel 'global'


  set_get_current_user_handler = ft.models.base.set_get_current_user_handler
  
  current_user_url = '/rest/v0/main/current/user'
  set_get_current_user_handler MainChannel, current_user_url
      
  
  handles.set_mainpage_init_handler()
  handles.set_main_navbar_handler()

  #layout = Views.BootstrapNoGridLayout
  #navbar = Views.BootstrapNavBarView
  #MainPage.set_init_page_handler MainBus, 'nogridpage', layout, navbar

  
  
  # require applets
  require 'frontdoor/main'
  require 'wiki/main'
  require 'bumblr/main'
  require 'hubby/main'
  

      
  app = new Marionette.Application()
  app.ready = false

  console.log AppModel
  
  user = MainChannel.reqres.request 'main:app:current-user'
  response = user.fetch()
  response.done ->
    handles.prepare_app app, AppModel
    app.ready = true

  
  module.exports = app
  
    
