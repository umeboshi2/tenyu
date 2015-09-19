define (require, exports, module) ->
  $ = require 'jquery'
  jQuery = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  ft = require 'furniture'
  
  AppRegions = ft.misc.appregions
  
  appmodel = new Backbone.Model
    brand:
      name: 'Pergola'
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
      ]
    regions: AppRegions.basic_appregions
    routes: [
      'frontdoor:route'
      'wiki:route'
      'bumblr:route'
      'hubby:route'
      ]
    
      
  module.exports = appmodel
  
  
    
