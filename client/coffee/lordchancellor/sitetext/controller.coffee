define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  
  Views = require 'sitetext/views'
  require 'sitetext/collections'
    
  { SideBarController } = ft.controllers.sidebar

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'sitetext'


  { navbar_set_active
    scroll_top_fast } = ft.util

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'List Pages'
        url: '#sitetext/listpages'
      }
      {
        name: 'Add Page'
        url: '#sitetext/addpage'
      }
      ]

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data
    pages: AppChannel.reqres.request 'get-pages'
    make_main_content: ->
      @make_sidebar()
      #@show_page 1
      
    list_pages: ->
      @make_sidebar()
      response = @pages.fetch()
      response.done =>
        view = new Views.PageListView
          collection: @pages
        @_show_content view

    add_page: ->
      @make_sidebar()
      #console.log "add_page called on controller"
      view = new Views.NewPageFormView
      @_show_content view

    _show_page: (page) ->
      #window.showpage = page
      #console.log "_show_page for #{page} called on controller"
      #console.log page
      view = new Views.ShowPageView
        model: page
      @_show_content view
            
    show_page: (name) ->
      @make_sidebar()
      # we do this if/else in case this url is called
      # as the entry point.  This should probably be
      # generalized in a base controller class. 
      # we should probably check for length of pages
      content = MainChannel.reqres.request 'main:app:get-region', 'content'
      if not content.hasView()
        content.empty()
        response = @pages.fetch()
        response.done =>
          page = @pages.get name
          @_show_page page
      else
        page = AppChannel.reqres.request 'get-page', name
        @_show_page page
      
    edit_page: (name) ->
      @make_sidebar()
      #console.log "Get page named #{name} for editing"
      page = AppChannel.reqres.request 'get-page', name
      #console.log "Here is the page #{page}"
      view = new Views.EditPageView
        model: page
      @_show_content view
      
    start: ->
      content = MainChannel.reqres.request 'main:app:get-region', 'content'
      if content.hasView()
        content.empty()
      #console.log 'controller.start called'
      @make_main_content()
      #console.log 'wiki started'

  module.exports = Controller
  
