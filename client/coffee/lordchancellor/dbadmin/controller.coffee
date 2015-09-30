define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'

  Views = require 'dbadmin/views'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'dbadmin'

  
  { SideBarController } = ft.controllers.sidebar
  

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'DB Main'
        url: '#dbadmin'
      }
      ]

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data

    make_main_content: ->
      @make_sidebar()
      info = AppChannel.reqres.request 'dbadmin:get-info'
      response = info.fetch()
      response.done =>
        window.annexinfo = info
        view = new Views.FrontDoorMainView
        view.model = info
        #model: info
        @_show_content view

    start: ->
      #console.log 'controller.start called'
      @make_main_content()
      #console.log 'dbadmin started'

  module.exports = Controller
  
