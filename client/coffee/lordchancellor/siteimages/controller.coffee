define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'

  Views = require 'siteimages/views'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'siteimages'

  
  { SideBarController } = ft.controllers.sidebar
  

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'Site Images'
        url: '#siteimages'
      }
      ]

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data

    make_main_content: ->
      @make_sidebar()
      @list_images()
      
    list_images: ->
      @make_sidebar()
      images = AppChannel.reqres.request 'collection:siteimages'
      response = images.fetch()
      response.done =>
        view = new Views.SiteImageListView
          collection: images
        @_show_content view
      window.images = images
      
    start: ->
      #console.log 'controller.start called'
      @make_main_content()
      #console.log 'siteimages started'

  module.exports = Controller
  
