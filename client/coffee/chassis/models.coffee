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

  class AppSettings extends BaseLocalStorageModel
    id: 'app_settings'

  app_settings = new AppSettings
  MainChannel.reqres.setHandler 'get_app_settings', ->
    app_settings
    
  class Page extends Backbone.Model
    validation:
      name:
        required: true
        
    
  module.exports =
    Page: Page
    
