define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  
  BaseLocalStorageModel = ft.models.localstorage
    
  baseURL = '/rest/v0/main/celerytasks'
  mainURL = "#{baseURL}/main"
  adminURL = "#{baseURL}/admin"
  ########################################
  # Models
  ########################################

  console.log "Hello chassis models"
  
  class AppSettings extends BaseLocalStorageModel
    id: 'app_settings'

  app_settings = new AppSettings
  MainChannel.reqres.setHandler 'get_app_settings', ->
    app_settings


  class CeleryTask extends Backbone.Model
    idAttribute: 'task_id'
    url: () ->
      "#{mainURL}/#{@id}"

  MainChannel.reqres.setHandler 'main:app:get-celery-task', (task_id) ->
    console.log 'setHandler main:app:get-celery-task'
    model = new CeleryTask
      task_id: task_id
    return model
    
      
        
    
  module.exports =
    CeleryTask: CeleryTask
    
