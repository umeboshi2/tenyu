define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'
  
  localStorage = require 'bblocalStorage'
  
  Models = require 'siteimages/models'
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'siteimages'
  
  { BaseCollection } = ft.collections    

  ########################################
  # Collections
  ########################################
  baseURL = '/rest/v0/main/siteimages'
  mainURL = "#{baseURL}/main"
  adminURL = "#{baseURL}/admin"

  class SiteImageCollection extends BaseCollection
    model: Models.SiteImage
    url: mainURL

  site_image_collection = new SiteImageCollection
  AppChannel.reqres.setHandler 'collection:siteimages', ->
    site_image_collection


  module.exports =
    SiteImageCollection: SiteImageCollection
