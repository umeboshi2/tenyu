define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  fullCalendar = require 'fullcalendar'  

  Views = require 'gitannex/views'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'gitannex'

  
  { SideBarController } = ft.controllers.sidebar
  

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'Annex Info'
        url: '#gitannex/annexinfo'
      }
      ]

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data

    show_annex_info: ->
      info = AppChannel.reqres.request 'repos:annex-info'
      response = info.fetch()
      response.done =>
        view = new Views.AnnexInfoView
          model: info
        @_show_content view

    make_main_content: ->
      @make_sidebar()
      @show_annex_info()

    show_calendar: ->
      @make_sidebar()
      view = new Views.RepoCalendarView
      @_show_content view
      
      
    start: ->
      #console.log 'controller.start called'
      @make_main_content()
      #console.log 'gitannex started'

  module.exports = Controller
  
