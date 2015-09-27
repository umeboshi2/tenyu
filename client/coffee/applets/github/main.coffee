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
      'github/showcalendar': 'show_calendar'
      'github/listusers': 'list_users'
      'github/showuser': 'show_user'
      'github/listrepos': 'list_repos'
      'github/listmyrepos': 'list_my_repos'
      'github/listotherrepos': 'list_other_repos'
      'github/showrepo/:id': 'show_repo'
      'github/listforks': 'list_forked_repos'
      
      #'github/listpages': 'list_pages'
      #'github/showpage/:name' : 'show_page'
      #'github/editpage/:name': 'edit_page'
      #'github/addpage': 'add_page'
      
  current_calendar_date = undefined
  AppChannel.reqres.setHandler 'maincalendar:set_date', () ->
    cal = $ '#maincalendar'
    current_calendar_date = cal.fullCalendar 'getDate'

  AppChannel.reqres.setHandler 'maincalendar:get_date', () ->
    current_calendar_date
    
  MainChannel.reqres.setHandler 'applet:github:route', () ->
    #console.log "github:route being handled"
    controller = new Controller MainChannel
    router = new Router
      controller: controller
    #console.log 'github router created'
