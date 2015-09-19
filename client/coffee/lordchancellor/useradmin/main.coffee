define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'

  # require this for msgbus handlers
  require 'useradmin/collections'
  
  Controller = require 'useradmin/controller'

  MainChannel = Backbone.Wreqr.radio.channel 'global'


  { BootStrapAppRouter } = ft.approuters.bootstrap
    
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'useradmin': 'start'
      'useradmin/listusers': 'list_users'
      'useradmin/adduser': 'add_user'
      'useradmin/listgroups': 'list_groups'
      'useradmin/addgroup': 'add_group'
      'useradmin/viewuser/:id': 'view_user'

  MainChannel.reqres.setHandler 'applet:useradmin:route', () ->
    console.log 'applet:useradmin:route being handled'
    controller = new Controller MainChannel
    router = new Router
      controller: controller
