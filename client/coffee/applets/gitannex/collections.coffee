define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'
  
  localStorage = require 'bblocalStorage'
  
  Models = require 'gitannex/models'
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'gitannex'
  
  { BaseCollection } = ft.collections    

  ########################################
  # Collections
  ########################################
  baseURL = '/rest/v0/main/gitannex'

  class AnnexRepoCollection extends BaseCollection
    model: Models.AnnexRepo
    url: "#{baseURL}/repos"

  annex_repo_collection = new AnnexRepoCollection
  AppChannel.reqres.setHandler 'repos:collection', ->
    annex_repo_collection

  module.exports =
    AnnexRepoCollection: AnnexRepoCollection
