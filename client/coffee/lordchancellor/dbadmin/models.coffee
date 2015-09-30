define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  AppChannel = Backbone.Wreqr.radio.channel 'dbadmin'
    
  ########################################
  # Models
  ########################################
  baseURL = '/rest/v0/main/dbadmin'
  mainURL = "#{baseURL}/main"
  adminURL = "#{baseURL}/admin"

  class DBInfo extends Backbone.Model
    url: () ->
      "#{mainURL}"

  db_info = new DBInfo
  AppChannel.reqres.setHandler 'dbadmin:get-info', () ->
    console.log "setHandler dbadmin:get-info"
    db_info
  
  module.exports =
    DBInfo: DBInfo
    
    
