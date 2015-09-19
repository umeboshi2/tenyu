define (require, exports, module) ->
  $ = require 'jquery'
  jQuery = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  ft = require 'furniture'
  

  appmodel = new Backbone.Model
    hasUser: true
    brand:
      name: 'Cenotaph'
      url: '#'
    frontdoor_app: 'frontdoor'
    applets:
      [
        {
          appname: 'conspectus'
          name: 'Conspectus'
          url: '/app/conspectus'
        }
      ]
    regions: ft.misc.appregions.user_appregions
    routes: [
      'frontdoor:route'
      ]
    
  
  module.exports = appmodel
  
  
    
