define (require, exports, module) ->
  $ = require 'jquery'
  jQuery = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  bootstrap = require 'bootstrap'
  Marionette = require 'marionette'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'
  
  #MainPage = ft.misc.mainpage

  
  AppModel = require 'appmodel'

  
  MainChannel = Backbone.Wreqr.radio.channel 'global'

  # require applets
  require 'frontdoor/main'
  require 'wiki/main'
  require 'bumblr/main'
  require 'hubby/main'

  app = new Marionette.Application()
  # attach app to window
  window.App = app

  app.ready = false
  ft.misc.mainhandles.set_mainpage_init_handler()
  
  ft.misc.mainhandles.prepare_app app, AppModel

  
    
  app.ready = true
  
  module.exports = app
  
    
