define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  
  Models = require 'wiki/models'

  Templates = require 'wiki/templates'

  # ace requirements
  require 'ace/theme-twilight'
  require 'ace/mode-markdown'
  
  AppChannel = Backbone.Wreqr.radio.channel 'wiki'
  
  FormView = ft.views.formview
  { navigate_to_url } = ft.util
    
  BaseEditPageView = ft.views.editor
  BaseSideBarView = ft.views.sidebar
  

  
  
  class FrontDoorMainView extends Backbone.Marionette.ItemView
    template: Templates.frontdoor_main

  class SideBarView extends BaseSideBarView
    
  class PageListEntryView extends Backbone.Marionette.ItemView
    template: Templates.page_list_entry
    
  class PageListView extends Backbone.Marionette.CompositeView
    template: Templates.page_list
    childView: PageListEntryView
    childViewContainer: '.listview-list'
    # handle new page button click
    events:
      'click #add-new-page-button': 'add_new_page_pressed'
      
    add_new_page_pressed: () ->
      #console.log 'add_new_page_pressed called'
      navigate_to_url '#wiki/addpage'
      
  class ShowPageView extends Backbone.Marionette.ItemView
    template: Templates.show_page_view


  class EditPageView extends BaseEditPageView
    template: Templates.edit_page

  class NewPageFormView extends FormView
    ui:
      name: '[name="name"]'
      content: '[name="content"]'

    template: Templates.new_page_form

    createModel: ->
      new Models.Page
        validation:
          name:
            required: true
          content:
            required: true
            
      
    updateModel: ->
      collection = AppChannel.reqres.request 'pages:collection'
      page_id = @ui.name.val()
      @model.set
        id: page_id
        name: page_id
        content: @ui.content.val()
      collection.add @model

    onSuccess: (model) ->
      navigate_to_url '#wiki/editpage/' + model.get 'id'

    onFailure: (model) ->
      #alert "Failed"
      
      
  module.exports =
    FrontDoorMainView: FrontDoorMainView
    SideBarView: SideBarView
    PageListView: PageListView
    ShowPageView: ShowPageView
    EditPageView: EditPageView
    NewPageFormView: NewPageFormView
    
    
