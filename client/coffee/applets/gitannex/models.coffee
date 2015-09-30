define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  AppChannel = Backbone.Wreqr.radio.channel 'gitannex'
    
  ########################################
  # Models
  ########################################
  baseURL = '/rest/v0/main/gitannex'

  class AnnexRepo extends Backbone.Model
    url: () ->
      "#{baseURL}/repos/#{@id}"
    
  class AnnexInfo extends AnnexRepo
    url: () ->
      "#{baseURL}/dbadmin"
    id: 'main'

  annex_info = new AnnexInfo
  AppChannel.reqres.setHandler 'repos:annex-info', ->
    annex_info

  AppChannel.reqres.setHandler 'repos:get-repo', (repo_id) ->
    m = new AnnexRepo
      id: repo_id
    return m
  
  module.exports =
    AnnexRepo: AnnexRepo
    AnnexInfo: AnnexInfo
