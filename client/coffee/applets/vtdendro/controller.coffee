define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  qs = require 'qs'
  fullCalendar = require 'fullcalendar'
  ft = require 'furniture'

  Views = require 'vtdendro/views'
  Models = require 'vtdendro/models'
  Collections = require 'vtdendro/collections'
    
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'vtdendro'
  Util = ft.util
  

  { SideBarController } = ft.controllers.sidebar

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'Genus List'
        url: '#vtdendro/genuslist'
      }
      {
        name: 'VTSpecies List'
        url: '#vtdendro/vtspecieslist'
      }
      {
        name: 'Search Me'
        url: '#vtdendro/vtsearch'
      }
      {
        name: 'WikiPages'
        url: '#vtdendro/wikipagelist'
      }
      ]

  class Controller extends SideBarController
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data
    
    init_page: ->
      #console.log 'init_page', @App
      #view = new Views.BlogModal()
      #modal = MainChannel.reqres.request 'main:app:get-region', 'modal'
      #modal.show view
      
    set_header: (title) ->
      header = $ '#header'
      header.text title
      
    start: ->
      content = MainChannel.reqres.request 'main:app:get-region', 'content'
      sidebar = MainChannel.reqres.request 'main:app:get-region', 'sidebar'
      if content.hasView()
        console.log 'empty content....'
        content.empty()
      if sidebar.hasView()
        console.log 'empty sidebar....'
        sidebar.empty()
      @set_header 'VT Dendro'
      @vtspecies_list()
      
    show_mainview: () ->
      @make_sidebar()
      view = new Views.SimpleGenusListView
      @_show_content view
      Util.scroll_top_fast()
      
    search_vtspecies: () ->
      @make_sidebar()
      view = new Views.SearchVTSpeciesView
      @_show_content view
      Util.scroll_top_fast()
      
    genus_list: () ->
      #console.log 'genus_list called'
      @make_sidebar()
      glist = AppChannel.reqres.request 'get_genus_collection'
      response = glist.fetch()
      #console.log 'my glist response', response
      response.done =>
        #console.log "response.done for glist"
        view = new Views.SimpleGenusListView
          collection: glist
          model: new Backbone.Model glist.state
        @_show_content view
        Util.scroll_top_fast()
        window.gview = view
        
    list_wikipages: () ->
      @make_sidebar()
      wlist = AppChannel.reqres.request 'get_wikipage_collection'
      response = wlist.fetch()
      response.done =>
        view = new Views.WikiPageListView
          collection: wlist
        @_show_content view
        Util.scroll_top_fast()
        
    
    vtspecies_list: () ->
      @make_sidebar()
      vlist = AppChannel.reqres.request 'get_vtspecies_collection'
      response = vlist.fetch()
      response.done =>
        view = new Views.SimpleVTSpeciesListView
          collection: vlist
        @_show_content view
        Util.scroll_top_fast()

    view_genus: (name) ->
      @make_sidebar()
      console.log "name", name
      vlist = AppChannel.reqres.request 'make_vtgenus_collection', name
      response = vlist.fetch()
      response.done =>
        vlist.state.genus = new Models.Genus
        vlist.state.genus.genus = name
        gresponse = vlist.state.genus.fetch()
        gresponse.done =>
          view = new Views.VTSpeciesGenusListView
            collection: vlist
            model: new Backbone.Model vlist.state
          @_show_content view
          Util.scroll_top_fast()

    show_search_results: (queryString) ->
      @make_sidebar()
      params = qs.parse queryString
      vlist = AppChannel.reqres.request 'make_vtsearch_collection', params
      response = vlist.fetch()
      response.done =>
        view = new Views.SimpleVTSpeciesListView
          collection: vlist
        @_show_content view
        Util.scroll_top_fast()

    view_wikipage: (name) ->
      @make_sidebar()
      wpage = new Models.WikiPage
      wpage.name = name
      response = wpage.fetch()
      response.done =>
        view = new Views.WikiPageView
          model: wpage
        @_show_content view
        Util.scroll_top_fast()
        
      
      

    view_vtspecies: (id) ->
      @make_sidebar()
      console.log 'view_vtspecies id', id
      vlist = AppChannel.reqres.request 'get_vtspecies_collection'
      specmodel = new Models.VTSpecies
      specmodel.id = id
      response = specmodel.fetch()
      response.done =>
        #window.specmodel = specmodel
        console.log "response.done id", id
        spec = specmodel
        view = new Views.VTSpecView
          model: spec
        @_show_content view
        Util.scroll_top_fast()
      
  module.exports = Controller
  
