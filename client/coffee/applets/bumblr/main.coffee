#
define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  Controller = require 'bumblr/controller'

  Util = ft.util
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'bumblr'



  { BootStrapAppRouter } = ft.approuters.bootstrap
  

  # FIXME: this is to make sure that AppBus handlers
  # are running
  Models = require 'bumblr/models'  
  require 'bumblr/collections'
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'bumblr': 'start'
      'bumblr/settings': 'settings_page'
      'bumblr/dashboard': 'show_dashboard'
      'bumblr/listblogs': 'list_blogs'
      'bumblr/viewblog/:id': 'view_blog'
      'bumblr/addblog' : 'add_new_blog'
      
  current_calendar_date = undefined
  AppChannel.reqres.setHandler 'maincalendar:set_date', () ->
    cal = $ '#maincalendar'
    current_calendar_date = cal.fullCalendar 'getDate'

  AppChannel.reqres.setHandler 'maincalendar:get_date', () ->
    current_calendar_date
    
  MainChannel.reqres.setHandler 'applet:bumblr:route', () ->
    console.log "bumblr:route being handled..."
    blog_collection = AppChannel.reqres.request 'get_local_blogs'
    response = blog_collection.fetch()
    response.done =>
      controller = new Controller MainChannel
      router = new Router
        controller: controller
      #console.log 'bumblr router created'
