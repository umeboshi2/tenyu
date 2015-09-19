define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  Controller = require 'wiki/controller'
  
  # require this for msgbus handlers
  require 'wiki/collections'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'wiki'
  
  { BootStrapAppRouter } = ft.approuters.bootstrap
    
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'wiki': 'start'
      'wiki/listpages': 'list_pages'
      'wiki/showpage/:name' : 'show_page'
      'wiki/editpage/:name': 'edit_page'
      'wiki/addpage': 'add_page'
      
  MainChannel.reqres.setHandler 'applet:wiki:route', () ->
    console.log "wiki:route being handled"
    page_collection = AppChannel.reqres.request 'pages:collection'
    response = page_collection.fetch()
    response.done =>
      controller = new Controller MainChannel
      router = new Router
        controller: controller
      console.log 'wiki router created'
