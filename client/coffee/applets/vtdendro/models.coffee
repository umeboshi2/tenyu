define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  BaseLocalStorageModel = require 'common/localstoragemodel'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'vtdendro'
  
  ########################################
  # Models
  ########################################
  baseURL = 'http://api.tumblr.com/v2'
  
  class VtdendroSettings extends BaseLocalStorageModel
    id: 'vtdendro_settings'

  class BaseTumblrModel extends Backbone.Model
    baseURL: baseURL
    
  class BlogInfo extends BaseTumblrModel
    url: () ->
      "#{@baseURL}/blog/#{@id}/info?api_key=#{@api_key}&callback=?"

  class VTSpecies extends Backbone.Model
    url: () ->
      "/rest/v0/main/vtspecies/#{@id}"

  class Genus extends Backbone.Model
    url: () ->
      "/rest/v0/main/genus/#{@genus}"

  class WikiPage extends Backbone.Model
    url: () ->
      "/rest/v0/main/wikipage/#{@name}"
      
  module.exports =
    BlogInfo: BlogInfo
    VTSpecies: VTSpecies
    Genus: Genus
    WikiPage: WikiPage
    
