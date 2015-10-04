define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  AppChannel = Backbone.Wreqr.radio.channel 'webobjects'
    
  ########################################
  # Models
  ########################################
  baseURL = '/rest/v0/main/webobjects'
  mainURL = "#{baseURL}/main"
  adminURL = "#{baseURL}/admin"

  class WebObject extends Backbone.Model
    url: () ->
      "#{mainURL}/#{@id}"

    validation:
      name:
        required: true
        msg: 'Name required.'

      type:
        required: true
        msg: 'Type required.'


  AppChannel.reqres.setHandler 'webobjects:get-object', (object_id) ->
    m = new WebObject
      id: object_id
    return m
  
  module.exports =
    WebObject: WebObject
    
    
