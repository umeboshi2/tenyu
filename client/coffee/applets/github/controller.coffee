define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'

  Views = require 'github/views'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'github'

  
  { SideBarController } = ft.controllers.sidebar
  

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'Home'
        url: '#'
      }
      {
        name: 'List Users'
        url: '#github/listusers'
      }
      ]

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data

    make_main_content: ->
      @make_sidebar()
      #@show_page 'intro'
      #@list_users()
      @list_repos()
      
    list_repos: ->
      @make_sidebar()
      repos = AppChannel.reqres.request 'repos:collection'
      response = repos.fetch()
      response.done =>
        view = new Views.RepoListView
          collection: repos
        @_show_content view
            
    list_users: ->
      @make_sidebar()
      users = AppChannel.reqres.request 'users:collection'
      response = users.fetch()
      response.done =>
        view = new Views.UserListView
          collection: users
        @_show_content view
            
    show_user: (name) ->
      @make_sidebar()
      page = AppChannel.reqres.request 'users:getuser', name
      view = new Views.FrontDoorMainView
        model: page
      @_show_content view
  
    start: ->
      #console.log 'controller.start called'
      @make_main_content()
      #console.log 'github started'

  module.exports = Controller
  
