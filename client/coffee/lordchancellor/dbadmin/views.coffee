define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  tc = require 'teacup'
  
  
  Models = require 'dbadmin/models'

  Templates = require 'dbadmin/templates'

  # ace requirements
  require 'ace/theme/twilight'
  require 'ace/mode/markdown'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'dbadmin'
  
  FormView = ft.views.formview
  { navigate_to_url
    make_json_post } = ft.util
    
  BaseEditPageView = ft.views.editor
  BaseSideBarView = ft.views.sidebar
  

  
  baseURL = "/rest/v0/main/dbadmin/main"
  
  class FrontDoorMainView extends Backbone.Marionette.ItemView
    template: Templates.frontdoor_main
    ui:
      populate_btn: '#populatedb'
      delete_btn: '#deletedb'
      setuprepos_btn: '#setuprepos'
      
    events:
      'click @ui.populate_btn': 'populate_database'
      'click @ui.delete_btn': 'delete_database'
      
    populate_database: () ->
      console.log "{POPULATE_DATABASE}"
      @ui.populate_btn.hide()

      action = 'populate_database'
      data =
        action: action
        database: 'gitannex'
      response = make_json_post baseURL, data
      response.done =>
        window.response = response
        @model.set response.responseJSON
        @render()
        
    delete_database: () ->
      console.log "{DELETE_DATABASE}"
      @ui.delete_btn.hide()
      data =
        database: 'gitannex'
        
      response = make_json_post baseURL, data, 'DELETE'
      response.done =>
        window.response = response
        @model.set response.responseJSON
        @render()

    

  class SideBarView extends BaseSideBarView

      
      
      
  module.exports =
    FrontDoorMainView: FrontDoorMainView
    SideBarView: SideBarView
