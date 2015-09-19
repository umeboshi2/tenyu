define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  Wreqr = require 'backbone.wreqr'
  ft = require 'furniture'

  Models = require 'useradmin/models'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'useradmin'
  
  # FIXME: furniture needs more than base collection!
  { BaseCollection } = ft.collections
        

  ########################################
  # Collections
  ########################################
  rscroot = '/rest/v0/main'
  
  class UserList extends BaseCollection
    model: Models.User
    url: "#{rscroot}/users"

  class GroupList extends BaseCollection
    model: Models.Group
    url: "#{rscroot}/groups"

  MainUserList = new UserList
  MainGroupList = new GroupList

  make_ug_collection = (user_id) ->
    class uglist extends BaseCollection
      model: Models.Group
      url: "#{rscroot}/users/#{user_id}/groups"
    return new uglist
    
  AppChannel.reqres.setHandler 'get-users', ->
    MainUserList
  AppChannel.reqres.setHandler 'get-groups', ->
    MainGroupList
  
  module.exports =
    MainUserList: MainUserList
    MainGroupList: MainGroupList
    make_ug_collection: make_ug_collection
    
    
