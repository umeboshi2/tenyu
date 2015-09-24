define (require, exports, module) ->
  ft = require 'furniture'
  AppRegions = ft.misc.appregions
  BaseAppModel = ft.models.base.BaseAppModel

  appmodel = new BaseAppModel
    brand:
      name: 'Lorax'
      url: '#'
    frontdoor_app: 'frontdoor'
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
        {
          appname: 'bookstore'
          name: 'Bookstore'
          url: '#bookstore'
        }
        {
          appname: 'vtdendro'
          name: 'VTDendro'
          url: '#vtdendro'
        }
      ]
    regions: AppRegions.basic_appregions
    routes: [
      'frontdoor:route'
      'wiki:route'
      'bumblr:route'
      'hubby:route'
      'bookstore:route'
      'vtdendro:route'
      ]
    
      
  module.exports = appmodel
  
    
