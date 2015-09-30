define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  Controller = require 'gitannex/controller'
  
  # require this for msgbus handlers
  require 'gitannex/collections'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'gitannex'
  
  { BootStrapAppRouter } = ft.approuters.bootstrap
    
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'gitannex': 'start'
      'gitannex/showcalendar': 'show_calendar'

      
  current_calendar_date = undefined
  AppChannel.reqres.setHandler 'maincalendar:set_date', () ->
    cal = $ '#maincalendar'
    current_calendar_date = cal.fullCalendar 'getDate'

  AppChannel.reqres.setHandler 'maincalendar:get_date', () ->
    current_calendar_date
    
  MainChannel.reqres.setHandler 'applet:gitannex:route', () ->
    #console.log "gitannex:route being handled"
    controller = new Controller MainChannel
    router = new Router
      controller: controller
    #console.log 'gitannex router created'
