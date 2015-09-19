define (require, exports, module) ->
  ft = require 'furniture'
  AppRegions = ft.misc.appregions

  appmodel = new Backbone.Model
    brand:
      name: 'Chassis'
      url: '/'
    frontdoor_app: 'frontdoor'
    hasUser: true
    applets:
      [
        {
          appname: 'wiki'
          name: 'Wiki'
          url: '#wiki'
        }
        {
          appname: 'bumblr'
          name: 'Bumblr'
          url: '#bumblr'
        }
        {
          appname: 'hubby'
          name: 'Hubby'
          url: '#hubby'
        }
      ]
    regions: AppRegions.user_appregions
    routes: [
      'frontdoor:route'
      'wiki:route'
      'bumblr:route'
      'hubby:route'
      ]
      
  module.exports = appmodel
  
    
