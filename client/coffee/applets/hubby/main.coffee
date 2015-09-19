#
define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'

  Controller = require 'hubby/controller'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'hubby'

  { BootStrapAppRouter } = ft.approuters.bootstrap

  class Router extends BootStrapAppRouter
    appRoutes:
      'hubby': 'start'
      'hubby/viewmeeting/:id': 'show_meeting'
      'hubby/listmeetings': 'list_meetings'
      
  current_calendar_date = undefined
  AppChannel.reqres.setHandler 'maincalendar:set_date', () ->
    cal = $ '#maincalendar'
    current_calendar_date = cal.fullCalendar 'getDate'

  AppChannel.reqres.setHandler 'maincalendar:get_date', () ->
    current_calendar_date
    
  MainChannel.reqres.setHandler 'applet:hubby:route', () ->
    console.log "applet:hubby:route being handled..."
    controller = new Controller MainChannel
    router = new Router
      controller: controller
      
