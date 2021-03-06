define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'bumblr'
  BaseLocalStorageModel = ft.models.localstorage
  
  ########################################
  # Models
  ########################################
  baseURL = 'http://api.tumblr.com/v2'
  
  class BumblrSettings extends BaseLocalStorageModel
    id: 'bumblr_settings'

  class BaseTumblrModel extends Backbone.Model
    baseURL: baseURL
    
  class BlogInfo extends BaseTumblrModel
    url: () ->
      "#{@baseURL}/blog/#{@id}/info?api_key=#{@api_key}&callback=?"
      
  #bumblr_settings = new BumblrSettings id:'bumblr'
  consumer_key = '4mhV8B1YQK6PUA2NW8eZZXVHjU55TPJ3UZnZGrbSoCnqJaxDyH'
  bumblr_settings = new BumblrSettings consumer_key:consumer_key
  AppChannel.reqres.setHandler 'get_app_settings', ->
    bumblr_settings
      
  module.exports =
    BlogInfo: BlogInfo
    
