define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  Controller = require 'webobjects/controller'
  
  # require this for msgbus handlers
  require 'webobjects/collections'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'webobjects'
  
  { BootStrapAppRouter } = ft.approuters.bootstrap
    
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'webobjects': 'start'
      'webobjects/addobject': 'add_object'
      'webobjects/listobjects': 'list_objects'
      'webobjects/editobject/:id': 'edit_object'
      'webobjects/aceeditobject/:id': 'ace_edit_object'
      
      
  MainChannel.reqres.setHandler 'applet:webobjects:route', () ->
    #console.log "webobjects:route being handled"
    #objects = AppChannel.reqres.request 'collection:webobjects'
    #response = objects.fetch()
    #response.done =>
    controller = new Controller MainChannel
    router = new Router
      controller: controller
    #console.log 'webobjects router created'
