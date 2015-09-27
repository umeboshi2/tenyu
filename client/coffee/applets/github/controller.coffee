define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  fullCalendar = require 'fullcalendar'  

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
        name: 'Show Calendar'
        url: '#github/showcalendar'
      }  
      {
        name: 'List my Repos'
        url: '#github/listmyrepos'
      }  
      {
        name: 'List Forked Repos'
        url: '#github/listforks'
      }
      {
        name: 'List Other Repos'
        url: '#github/listotherrepos'
      }
      {
        name: 'List All Repos'
        url: '#github/listrepos'
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
      @list_my_repos()

    show_calendar: ->
      @make_sidebar()
      view = new Views.RepoCalendarView
      @_show_content view
      
      
    _list_repos: (request) ->
      @make_sidebar()
      repos = AppChannel.reqres.request request
      response = repos.fetch()
      response.done =>
        view = new Views.RepoListView
          collection: repos
        @_show_content view
        
    list_my_repos: ->
      @_list_repos 'myrepos:collection'
      
    list_repos: ->
      @_list_repos 'repos:collection'

    list_other_repos: ->
      @_list_repos 'others:collection'

    list_forked_repos: ->
      @_list_repos 'myforks:collection'
      
    show_repo: (repo_id) ->
      @make_sidebar()
      repo = AppChannel.reqres.request 'repos:get-repo', repo_id
      response = repo.fetch()
      response.done =>
        view = new Views.ShowReposView
          model: repo
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
  
