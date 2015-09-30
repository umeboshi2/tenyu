define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  Controller = require 'dbadmin/controller'
  
  # require this for msgbus handlers
  require 'dbadmin/collections'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'dbadmin'

  { BootStrapAppRouter } = ft.approuters.bootstrap
    
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'dbadmin': 'start'
      
  MainChannel.reqres.setHandler 'applet:dbadmin:route', () ->
    #console.log "dbadmin:route being handled"
    controller = new Controller MainChannel
    router = new Router
      controller: controller
    #console.log 'dbadmin router created'
