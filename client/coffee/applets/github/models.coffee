define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  AppChannel = Backbone.Wreqr.radio.channel 'github'
    
  ########################################
  # Models
  ########################################
  baseURL = '/rest/v0/main/ghub'

  class GHUser extends Backbone.Model
    url: () ->
      "#{baseURL}/users/#{@id}"

  class MainUser extends GHUser
    id: 'main'

  main_user = new MainUser
  AppChannel.reqres.setHandler 'users:main-user', ->
    main_user

  class GHRepo extends Backbone.Model
    url: () ->
      "#{baseURL}/repos/#{@id}"

  AppChannel.reqres.setHandler 'repos:get-repo', (repo_id) ->
    m = new GHRepo
      id: repo_id
    return m
    
  ignoreme = '/rest/v0/main/ghub/repocalendar'
  
  module.exports =
    GHUser: GHUser
    GHRepo: GHRepo
    MainUser: MainUser
