define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  
  BaseLocalStorageModel = ft.models.localstorage
    
  ########################################
  # Models
  ########################################

  class AppSettings extends Backbone.Model
    id: 'lordchancellor'

  #class AppModel = 'foo'
    

  app_settings = new AppSettings
  MainChannel.reqres.setHandler 'main:app:settings', ->
    app_settings
    
        
    
  module.exports =
    Page: Page
    
