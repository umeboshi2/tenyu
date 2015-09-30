define (require, exports, module) ->
  Backbone = require 'backbone'
  ft = require 'furniture'
  AppChannel = Backbone.Wreqr.radio.channel 'gitannex'
    
  ########################################
  # Models
  ########################################
  baseURL = '/rest/v0/main/siteimages'
  mainURL = "#{baseURL}/main"
  adminURL = "#{baseURL}/admin"

  class SiteImage extends Backbone.Model
    url: () ->
      "#{mainURL}/#{@id}"

    validation:
      name:
        required: true
        msg: 'Name required.'
      imagefile:
        required: true


  AppChannel.reqres.setHandler 'images:get-image', (image_id) ->
    m = new SiteImage
      id: image_id
    return m
  
  module.exports =
    SiteImage: SiteImage
    
    
