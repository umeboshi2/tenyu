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
      'webobjects/listimages': 'list_images'
      #'webobjects/showpage/:name' : 'show_page'
      #'webobjects/editpage/:name': 'edit_page'
      'webobjects/addimage': 'add_image'
      
  MainChannel.reqres.setHandler 'applet:webobjects:route', () ->
    #console.log "webobjects:route being handled"
    controller = new Controller MainChannel
    router = new Router
      controller: controller
    #console.log 'webobjects router created'
