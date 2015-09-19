#
# Simple entry app
define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'frontdoor'
  WikiChannel = Backbone.Wreqr.radio.channel 'wiki'
    
  Controller = require 'frontdoor/controller'

  { BootStrapAppRouter } = ft.approuters.bootstrap

  class Router extends BootStrapAppRouter
    appRoutes:
      '': 'start'
      'frontdoor': 'start'
      
  MainChannel.reqres.setHandler 'applet:frontdoor:route', () ->
    #console.log "frontdoor:route being handled!!!!!!!!!!!!!"
    controller = new Controller MainChannel
    router = new Router
      controller: controller
    #console.log 'frontdoor router created'
