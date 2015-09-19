define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'

  Views = require 'wiki/views'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'wiki'

  
  { SideBarController } = ft.controllers.sidebar
  

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'Home'
        url: '#'
      }
      {
        name: 'News'
        url: '#wiki/showpage/news'
      }
      {
        name: 'List Pages'
        url: '#wiki/listpages'
      }
      ]

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data

    make_main_content: ->
      @make_sidebar()
      @show_page 'intro'

    list_pages: ->
      @make_sidebar()
      pages = AppChannel.reqres.request 'pages:collection'
      response = pages.fetch()
      response.done =>
        view = new Views.PageListView
          collection: pages
        @_show_content view
            
    show_page: (name) ->
      @make_sidebar()
      page = AppChannel.reqres.request 'pages:getpage', name
      view = new Views.FrontDoorMainView
        model: page
      @_show_content view
  
    edit_page: (name) ->
      @make_sidebar()
      page = AppChannel.reqres.request 'pages:getpage', name
      view = new Views.EditPageView
        model: page
      @_show_content view

    add_page: () ->
      @make_sidebar()
      view = new Views.NewPageFormView
      @_show_content view
      
      
    start: ->
      #console.log 'controller.start called'
      @make_main_content()
      #console.log 'wiki started'

  module.exports = Controller
  
