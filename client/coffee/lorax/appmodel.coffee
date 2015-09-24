define (require, exports, module) ->
  ft = require 'furniture'
  AppRegions = ft.misc.appregions
  BaseAppModel = ft.models.base.BaseAppModel

  appmodel = new BaseAppModel
    brand:
      name: 'Lorax'
      url: '#'
    hasUser: true
    applets:
      [
        {
          appname: 'wiki'
          name: 'Wiki'
          url: '#wiki'
        }
        {
          appname: 'vtdendro'
          name: 'VTDendro'
          url: '#vtdendro'
        }
      ]
    regions: AppRegions.user_appregions
    routes: [
      'frontdoor:route'
      'wiki:route'
      'bumblr:route'
      'hubby:route'
      'bookstore:route'
      'vtdendro:route'
      ]
    
      
  module.exports = appmodel
  
    
