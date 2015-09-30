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
        {
          appname: 'siteimages'
          name: 'Site Images'
          url: '#siteimages'
        }
        {
          appname: 'dbadmin'
          name: 'DB Admin'
          url: '#dbadmin'
        }
        {
          appname: 'webobjects'
          name: 'WebObjects'
          url: '#webobjects'
        }
      ]
    regions: ft.misc.appregions.user_appregions
  
  module.exports = appmodel
