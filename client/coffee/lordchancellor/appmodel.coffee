define (require, exports, module) ->
  $ = require 'jquery'
  jQuery = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  appmodel = new Backbone.Model
    hasUser: true
    brand:
      name: 'Chassis'
      url: '/'
    frontdoor_app: 'frontdoor'
    applets:
      [
        {
          appname: 'useradmin'
          name: 'Accounts'
          url: '#useradmin'
        }
        {
          appname: 'sitetext'
          name: 'Site Text'
          url: '#sitetext'
        }
      ]
    regions: ft.misc.appregions.user_appregions
    routes: [
      'frontdoor:route'
      ]
    
  
  module.exports = appmodel
  
  
    
