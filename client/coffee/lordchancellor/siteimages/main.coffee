define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  Controller = require 'siteimages/controller'
  
  # require this for msgbus handlers
  require 'siteimages/collections'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'siteimages'
  
  { BootStrapAppRouter } = ft.approuters.bootstrap
    
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'siteimages': 'start'
      'siteimages/listimages': 'list_images'
      #'siteimages/showpage/:name' : 'show_page'
      #'siteimages/editpage/:name': 'edit_page'
      'siteimages/addimage': 'add_image'
      
  MainChannel.reqres.setHandler 'applet:siteimages:route', () ->
    #console.log "siteimages:route being handled"
    controller = new Controller MainChannel
    router = new Router
      controller: controller
    #console.log 'siteimages router created'
