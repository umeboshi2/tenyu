define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'

  Views = require 'webobjects/views'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'webobjects'

  
  { SideBarController } = ft.controllers.sidebar
  

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'DB Main'
        url: '#webobjects'
      }
      ]

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data

    make_main_content: ->
      @make_sidebar()

    list_images: ->
      @make_sidebar()
      images = AppChannel.reqres.request 'collection:webobjects'
      response = images.fetch()
      response.done =>
        view = new Views.SiteImageListView
          collection: images
        @_show_content view
      window.images = images
      
    add_image: () ->
      @make_sidebar()
      view = new Views.NewSiteImageFormView
      @_show_content view
      
      
    start: ->
      #console.log 'controller.start called'
      @make_main_content()
      #console.log 'webobjects started'

  module.exports = Controller
  
