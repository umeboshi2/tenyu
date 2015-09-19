define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'
  
  Controller = require 'sitetext/controller'
  MainChannel = Backbone.Wreqr.radio.channel 'global'

  
  { BootStrapAppRouter } = ft.approuters.bootstrap

  class Router extends BootStrapAppRouter
    appRoutes:
      'sitetext': 'start'
      'sitetext/listpages': 'list_pages'
      'sitetext/addpage': 'add_page'
      'sitetext/editpage/:name': 'edit_page'
      'sitetext/showpage/:name': 'show_page'

  MainChannel.reqres.setHandler 'applet:sitetext:route', () ->
    #console.log "frontdoor:route being handled"
    #page_collection = WikiChannel.reqres.request 'get-pages'
    #response = page_collection.fetch()
    #response.done =>
    controller = new Controller MainChannel
    router = new Router
      controller: controller
    console.log 'sitetext router created'
