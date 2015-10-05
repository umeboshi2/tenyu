define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  tc = require 'teacup'
  
  
  Models = require 'dbadmin/models'

  Templates = require 'dbadmin/templates'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'dbadmin'
  
  FormView = ft.views.formview
  { navigate_to_url
    make_json_post } = ft.util
    
  BaseSideBarView = ft.views.sidebar
  

  
  baseURL = "/rest/v0/main/dbadmin/main"
  
  class FrontDoorMainView extends Backbone.Marionette.ItemView
    template: Templates.frontdoor_main
    ui:
      populate_gitannex_btn: '#populate-gitannex'
      delete_gitannex_btn: '#delete-gitannex'
      delete_siteimages_btn: '#delete-site-images'
        
    events:
      'click @ui.populate_gitannex_btn': 'populate_gitannex_database'
      'click @ui.delete_gitannex_btn': 'delete_gitannex_database'
      'click @ui.delete_siteimages_btn': 'delete_siteimages'

      
    populate_gitannex_database: () ->
      console.log "{POPULATE_DATABASE}"
      @ui.populate_gitannex_btn.hide()

      action = 'populate_database'
      data =
        action: action
        database: 'gitannex'
      response = make_json_post baseURL, data
      response.done =>
        window.response = response
        @model.set response.responseJSON
        @render()

    _delete_db: (database) ->
      data =
        database: database
      response = make_json_post baseURL, data, 'DELETE'
      response.done =>
        window.response = response
        @model.set response.responseJSON
        @render()
        
    delete_gitannex_database: () ->
      console.log "{DELETE_DATABASE}"
      @ui.delete_gitannex_btn.hide()
      @_delete_db 'gitannex'
        
    delete_siteimages: ->
      console.log "{DELETE_SITEIMAGES}"
      @ui.delete_siteimages_btn.hide()
      @_delete_db 'siteimages'
    

  class SideBarView extends BaseSideBarView

      
      
      
  module.exports =
    FrontDoorMainView: FrontDoorMainView
    SideBarView: SideBarView
