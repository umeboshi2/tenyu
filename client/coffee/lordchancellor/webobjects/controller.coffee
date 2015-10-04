define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'

  
  Views = require 'webobjects/views'
  Models = require 'webobjects/models'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'webobjects'

  
  { SideBarController } = ft.controllers.sidebar
  

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'Web Objects'
        url: '#webobjects'
      }
      {
        name: 'New Object'
        url: '#webobjects/addobject'
      }
      ]

  class Controller extends SideBarController
    mainbus: MainChannel
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data

    make_main_content: ->
      @make_sidebar()
      #view = new Views.FrontDoorMainView
      #@_show_content view
      @list_objects()

    list_objects: ->
      @make_sidebar()
      objects = AppChannel.reqres.request 'collection:webobjects'
      console.log "objects", objects
      response = objects.fetch()
      response.done =>
        view = new Views.WebObjectListView
          collection: objects
        @_show_content view
        window.wview = view
      window.webobjects = objects
      
    add_object: () ->
      @make_sidebar()
      objects = AppChannel.reqres.request 'collection:webobjects'
      view = new Views.NewWebObjectView
        collection: objects
      @_show_content view
      
    start: ->
      #console.log 'controller.start called'
      @make_main_content()
      #console.log 'webobjects started'

    edit_object: (object_id) ->
      @make_sidebar()
      #objects = AppChannel.reqres.request 'collection:webobjects'
      #model = Models.WebObject
      #  id: object_id
      model = AppChannel.reqres.request 'webobjects:get-object', object_id
      response = model.fetch()
      response.done =>
        view = new Views.EditWebObjectView
          model: model
        @_show_content view
      
    ace_edit_object: (object_id) ->
      @make_sidebar()
      #objects = AppChannel.reqres.request 'collection:webobjects'
      #model = Models.WebObject
      #  id: object_id
      model = AppChannel.reqres.request 'webobjects:get-object', object_id
      response = model.fetch()
      response.done =>
        view = new Views.AceEditObjectView
          model: model
        window.aview = view
        @_show_content view
      
  module.exports = Controller
  
