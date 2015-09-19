define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'

  Views = require 'useradmin/views'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'useradmin'


  { navbar_set_active
    scroll_top_fast } = ft.util

  { SideBarController } = ft.controllers.sidebar
    
  #    'useradmin/viewuser/:id': 'view_user'

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'List Users'
        url: '#useradmin/listusers'
      }
      {
        name: 'Add User'
        url: '#useradmin/adduser'
      }
      {
        name: 'List Groups'
        url: '#useradmin/listgroups'
      }
      {
        name: 'Add Group'
        url: '#useradmin/addgroup'
      }
      ]

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data

    make_main_content: ->
      @make_sidebar()

    list_users: ->
      @make_sidebar()
      userlist = AppChannel.reqres.request 'get-users'
      response = userlist.fetch()
      response.done =>
        view = new Views.UserListView
          collection: userlist
        @_show_content view

    add_user: ->
      @make_sidebar()
      console.log "add_user called on controller"
      view = new Views.NewUserFormView
      @_show_content view
      
    list_groups: ->
      @make_sidebar()
      console.log "list_groups called on controller"

      grouplist = AppChannel.reqres.request 'get-groups'
      response = grouplist.fetch()
      response.done =>
        view = new Views.GroupListView
          collection: grouplist
        @_show_content view
        

    add_group: ->
      @make_sidebar()
      console.log "add_group called on controller"
      #@set_header 'add group'
      
      view = new Views.NewGroupFormView
      @_show_content view

    view_user: (user_id) ->
      @make_sidebar()
      console.log "view_user called on controller"
      #@set_header 'view user'

      users = AppChannel.reqres.request 'get-users'
      
      view = new Views.ViewUserView
        model: users.get user_id
      @_show_content view
      
    start: ->
      content = MainChannel.reqres.request 'main:app:get-region', 'content'
      if content.hasView()
        content.empty()
      #console.log 'controller.start called'
      @make_main_content()
      #console.log 'wiki started'

  module.exports = Controller
  
