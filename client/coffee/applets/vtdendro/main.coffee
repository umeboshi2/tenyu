#
define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'

  Controller = require 'vtdendro/controller'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'vtdendro'

  { BootStrapAppRouter } = ft.approuters.bootstrap

  # required to set handlers
  Models = require 'vtdendro/models'  
  require 'vtdendro/collections'
  
  class Router extends BootStrapAppRouter
    appRoutes:
      'vtdendro': 'start'
      'vtdendro/genuslist': 'genus_list'
      'vtdendro/viewgenus/:name': 'view_genus'
      'vtdendro/vtspecieslist': 'vtspecies_list'
      'vtdendro/viewvtspecies/:id': 'view_vtspecies'
      'vtdendro/vtsearch': 'search_vtspecies'
      'vtdendro/vtshowsearch?*queryString' : 'show_search_results'
      'vtdendro/wikipage/:name': 'view_wikipage'
      'vtdendro/wikipagelist': 'list_wikipages'
      
      
      
    
  MainBus.commands.setHandler 'applet:vtdendro:route', () ->
    console.log "vtdendro:route being handled..."
    controller = new Controller MainChannel
    router = new Router
      controller: controller
    #console.log 'vtdendro router created'
