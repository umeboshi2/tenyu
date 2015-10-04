define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  Models = require 'sitetext/models'
  AppChannel = Backbone.Wreqr.radio.channel 'sitetext'
  
  { BaseCollection } = ft.collections
  
        
  ########################################
  # Collections
  ########################################
  rscroot = '/rest/v0/main'

  class PageCollection extends BaseCollection
    model: Models.GetPageModel
    url: "#{rscroot}/sitetextadmin"
    
  main_page_list = new PageCollection
  AppChannel.reqres.setHandler 'get-pages', ->
    window.main_page_list = main_page_list
    main_page_list

  AppChannel.reqres.setHandler 'get-page', (id) ->
    #console.log "get-page #{id}"
    main_page_list.get id
    
  module.exports =
    PageCollection: PageCollection
    
    
