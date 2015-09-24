define (require, exports, module) ->
  $ = require 'jquery'
  jQuery = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  ft = require 'furniture'
  BaseAppModel = ft.models.base.BaseAppModel
  
  appmodel = new BaseAppModel
    hasUser: true
    brand:
      name: 'Chassis'
      url: '/'
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
  
  module.exports = appmodel
  
  
    
