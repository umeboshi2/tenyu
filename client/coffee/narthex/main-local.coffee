# set path to components
components = '../../components'
# require config comes first
require.config
  baseUrl: '../javascripts/narthex'
  paths:
    ace: "#{components}/ace/lib/ace"
    backbone: "#{components}/backbone/backbone"
    'backbone.babysitter': "#{components}/backbone.babysitter/lib/backbone.babysitter"
    'backbone.paginator': "#{components}/backbone.paginator/lib/backbone.paginator"
    'backbone.wreqr': "#{components}/backbone.wreqr/lib/backbone.wreqr"
    bblocalStorage: "#{components}/backbone.localStorage/backbone.localStorage"
    bootstrap: "#{components}/bootstrap/dist/js/bootstrap"
    'doc-ready': "#{components}/doc-ready"
    eventEmitter: "#{components}/eventEmitter"
    eventie: "#{components}/eventie"
    'fizzy-ui-utils': "#{components}/fizzy-ui-utils"
    fullcalendar: "#{components}/fullcalendar/dist/fullcalendar"
    furniture: "#{components}/furniture/dist/furniture"
    'get-size': "#{components}/get-size"
    'get-style-property': "#{components}/get-style-property"
    imagesloaded: "#{components}/imagesloaded/imagesloaded"
    jquery: "#{components}/jquery/dist/jquery"
    'jquery-ui': "#{components}/jquery-ui/jquery-ui"
    marionette: "#{components}/backbone.marionette/lib/core/backbone.marionette"
    marked: "#{components}/marked/lib/marked"
    masonry: "#{components}/masonry/masonry"
    'matches-selector': "#{components}/matches-selector"
    moment: "#{components}/moment/moment"
    outlayer: "#{components}/outlayer"
    requirejs: "#{components}/requirejs/require"
    teacup: "#{components}/teacup/lib/teacup"
    underscore: "#{components}/lodash-compat/lodash"
    validation: "#{components}/backbone.validation/dist/backbone-validation-amd"

    
  # FIXME:  try to reduce the shim to only the
  # necessary resources
  shim:
    jquery:
      exports: ['$', 'jQuery']
    bootstrap:
      deps: ['jquery']
    underscore:
      exports: '_'
    backbone:
      deps: ['jquery', 'underscore']
      exports: 'Backbone'
    marionette:
      deps: ['jquery', 'underscore', 'backbone']
      exports: 'Marionette'
    bblocalStorage:
      deps: ['backbone']
      exports: 'Backbone.localStorage'

require [
  'application'
  'furniture'
  'frontdoor/main'
  ], (App, ft) ->
  # simple app starter
  return ft.util.start_application(App)
  
