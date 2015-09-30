define (require, exports, module) ->
  ft = require 'furniture'
  AppRegions = ft.misc.appregions
  BaseAppModel = ft.models.base.BaseAppModel

  appmodel = new BaseAppModel
    brand:
      name: 'Chassis'
      url: '/'
    hasUser: true
    applets:
      [
        {
          appname: 'wiki'
          name: 'Wiki'
          url: '#wiki'
        }
        {
          appname: 'github'
          name: 'Github'
          url: '#github'
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
          appname: 'gitannex'
          name: 'Git Annex'
          url: '#gitannex'
        }
      ]
    regions: AppRegions.user_appregions
    frontdoor_sidebar:
      [
        {
          name: 'Lorax'
          url: '/app/lorax'
        }
      ]
      
  module.exports = appmodel
  
    
