define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  Controller = require 'github/controller'
  
  # require this for msgbus handlers
  require 'github/collections'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'github'
  
  { BootStrapAppRouter } = ft.approuters.bootstrap
    
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'github': 'start'
      'github/listusers': 'list_users'
      'github/showuser': 'show_user'
      'github/listrepos': 'list_repos'
      
      #'github/listpages': 'list_pages'
      #'github/showpage/:name' : 'show_page'
      #'github/editpage/:name': 'edit_page'
      #'github/addpage': 'add_page'
      
  MainChannel.reqres.setHandler 'applet:github:route', () ->
    #console.log "github:route being handled"
    repo_collection = AppChannel.reqres.request 'repos:collection'
    response = repo_collection.fetch()
    response.done =>
      controller = new Controller MainChannel
      router = new Router
        controller: controller
      #console.log 'github router created'
