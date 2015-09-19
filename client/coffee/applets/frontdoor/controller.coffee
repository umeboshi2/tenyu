define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  marked = require 'marked'

  ft = require 'furniture'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  WikiChannel = Backbone.Wreqr.radio.channel 'wiki'
  
  Views = require 'frontdoor/views'


  Util = ft.util

  { SideBarController } = ft.controllers.sidebar

  make_sidebar_data = (appmodel) ->
    null
    
  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'Home'
        url: '#'
      }
      {
        name: 'Wiki'
        url: '#wiki'
      }
      {
        name: 'Bumblr'
        url: '#bumblr'
      }
      {
        name: 'Hubby'
        url: '#hubby'
      }
      ]
      

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data
      
    make_main_content: ->
      #console.log "make_main_content called in frontdoor/controller"
      @make_sidebar()
      @show_page 'intro'

    show_page: (name) ->
      @make_sidebar()
      page = WikiChannel.reqres.request 'pages:getpage', name
      #response = page.fetch()
      #response.done =>
      view = new Views.FrontDoorMainView
        model: page
      @_show_content view

    start: ->
      #console.log 'frontdoor controller.start called'
      @make_main_content()
      #console.log 'frontdoor started'

  module.exports = Controller
  
