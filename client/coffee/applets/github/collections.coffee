define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'
  
  localStorage = require 'bblocalStorage'
  
  Models = require 'github/models'
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'github'
  
  { BaseCollection } = ft.collections    

  ########################################
  # Collections
  ########################################
  class GHUserCollection extends BaseCollection
    model: Models.GHUse
    url: '/rest/v0/main/ghub/users'

  class GHRepoCollection extends BaseCollection
    model: Models.GHRepo
    url: '/rest/v0/main/ghub/repos'
    
  main_user_collection = new GHUserCollection
  AppChannel.reqres.setHandler 'users:collection', ->
    main_user_collection

  AppChannel.reqres.setHandler 'users:getuser', (user_id) ->
    main_user_collection.get user_id

  main_repo_collection = new GHRepoCollection
  AppChannel.reqres.setHandler 'repos:collection', ->
    main_repo_collection
      
  module.exports =
    GHUserCollection: GHUserCollection
    GHRepoCollection: GHRepoCollection
    
    
