# set path to components
components = '../../components'
# require config comes first
require.config
  baseUrl: '../javascripts/chassis'
  paths:
    ace: "https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.0"
    backbone: "https://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.2.3/backbone-min"
    'backbone.babysitter': "https://cdnjs.cloudflare.com/ajax/libs/backbone.babysitter/0.1.10/backbone.babysitter.min"
    #'backbone.paginator': "https://github.com/backbone-paginator/backbone.paginator/raw/master/lib/backbone.paginator.min"
    'backbone.paginator': "#{components}/backbone.paginator/lib/backbone.paginator"
    'backbone.radio': "https://cdnjs.cloudflare.com/ajax/libs/backbone.radio/1.0.2/backbone.radio.min"
    'backbone.wreqr': "https://cdnjs.cloudflare.com/ajax/libs/backbone.wreqr/1.3.5/backbone.wreqr.min"
    bblocalStorage: "https://cdnjs.cloudflare.com/ajax/libs/backbone-localstorage.js/1.1.16/backbone.localStorage-min"
    bootstrap: "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha/js/bootstrap.min"
    'doc-ready': "#{components}/doc-ready"
    eventEmitter: "https://cdnjs.cloudflare.com/ajax/libs/EventEmitter/4.3.0/EventEmitter.min"
    eventie: "#{components}/eventie"
    'fizzy-ui-utils': "#{components}/fizzy-ui-utils"
    fullcalendar: "https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/2.4.0/fullcalendar.min"
    furniture: "#{components}/furniture/dist/furniture"
    'get-size': "#{components}/get-size"
    'get-style-property': "#{components}/get-style-property"
    imagesloaded: "https://cdnjs.cloudflare.com/ajax/libs/jquery.imagesloaded/3.1.8/imagesloaded.pkgd.min"
    jquery: "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0-alpha1/jquery.min"
    'jquery-ui': "https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min"
    marionette: "https://cdnjs.cloudflare.com/ajax/libs/backbone.marionette/2.4.3/backbone.marionette.min"
    marked: "https://cdnjs.cloudflare.com/ajax/libs/marked/0.3.5/marked.min"
    masonry: "https://cdnjs.cloudflare.com/ajax/libs/masonry/3.3.2/masonry.pkgd.min"
    'matches-selector': "#{components}/matches-selector"
    moment: "https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/moment.min"
    outlayer: "#{components}/outlayer"
    requirejs: "https://cdnjs.cloudflare.com/ajax/libs/require.js/2.1.20/require.min"
    teacup: "#{components}/teacup/lib/teacup"
    #underscore: 'https://cdnjs.cloudflare.com/ajax/libs/lodash.js/3.10.1/lodash.min"
    underscore: "https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min"
    validation: "https://cdnjs.cloudflare.com/ajax/libs/backbone.validation/0.11.5/backbone-validation-min"
    qs: "#{components}/qs/dist/qs"
    'bootstrap-fileinput': "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-fileinput/4.2.7/js/fileinput.min"
    'json-editor': "https://cdnjs.cloudflare.com/ajax/libs/json-editor/0.7.23/jsoneditor.min"

    
    # applets
    github: '../applets/github'
    gitannex: '../applets/gitannex'
    hubby: '../applets/hubby'
    bumblr: '../applets/bumblr'
    wiki: '../applets/wiki'
    frontdoor: '../applets/frontdoor'
    vtdendro: '../applets/vtdendro'
    
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
    validation:
      deps: ['backbone']
    'backbone.paginator':
      deps: ['backbone']
      exports: 'Backbone.Paginator'
    'backbone.wreqr':
      deps: ['backbone']
      exports: 'Backbone.Wreqr'
    'bootstrap-fileinput':
      deps: ['jquery', 'bootstrap']
    'json-editor':
      deps: ['jquery', 'bootstrap']
      exports: 'JSONEditor'
      
    #qs:
    #  exports: 'qs'
      
  deps: ['require']
  #FIXME
  callback: (require) ->
    'use strict'
    filename = location.pathname.match(/\/([^\/]*)$/)
    console.log "Filename #{filename}"
    modulename = undefined
    if filename and filename[1] isnt "" or filename[0] == '/'
      modulename = [
        #"app"
        #filename[1].split(".")[0]
        "application"
      ].join("/")
      require [modulename, 'furniture'], (App, ft) ->
        App
    else
      console.log "no modulename found via location.pathname"  if window.console
    return
    
