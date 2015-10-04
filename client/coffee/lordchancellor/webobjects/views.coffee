define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  tc = require 'teacup'
  require 'json-editor'
  require 'bootstrap'
  ace = require 'ace/ace'
  
  Models = require 'webobjects/models'

  Templates = require 'webobjects/templates'

  # ace requirements
  require 'ace/theme/twilight'
  require 'ace/mode/markdown'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'webobjects'
  
  FormView = ft.views.formview
  { navigate_to_url
    make_json_post } = ft.util
    
  BaseEditPageView = ft.views.editor
  BaseSideBarView = ft.views.sidebar
  
  Marionette.Behaviors.behaviorsLookup = ->
    ft.behaviors
  

  jsonSchemaDraft4 = "http://json-schema.org/draft-04/schema"
  
  class SideBarView extends BaseSideBarView
  
  class FrontDoorMainView extends Backbone.Marionette.ItemView
    template: Templates.frontdoor_main

  class BaseWebObjectView extends Backbone.Marionette.ItemView
    template: Templates.edit_webobject
    ui:
      editor: '#editor'
      savebutton: '#save-button'
      alert: '#alert'
      object_name: '[name="name"]'
      object_type: '[name="type"]'
    events:
      'click @ui.savebutton': 'save_object'
      

    show_savebutton: ->
      @ui.savebutton.show()

    hide_savebutton: ->
      @ui.savebutton.hide()
      
    onDomRefresh: () ->
      window.fdview = @
      @editor = new JSONEditor @ui.editor[0],
        theme: 'bootstrap3'
        schema: jsonSchemaDraft4
        ajax: true
        iconlib: 'fontawesome4'

      @editor.on 'ready', () =>
        console.log 'editor erady'
        if @model
          @load_object @model, true
        @hide_savebutton()        
      @editor.on 'change', () =>
        #console.log "Something changed"
        @show_savebutton()

    load_object: (model=@model, hide_savebutton=false) ->
      @ui.object_name.val model.get 'name'
      @ui.object_type.val model.get 'type'
      @load_content model.get 'content', hide_savebutton
      if hide_savebutton
        @hide_savebutton()

    load_content: (content) ->
      @editor.setValue content
        
        
    onBeforeDestroy: () ->
      @editor.off 'changed', @show_savebutton
      @editor.destroy()
        
    remove_alert: () ->
      @ui.alert.empty()
      
  class EditWebObjectView extends BaseWebObjectView
    save_object: () ->
      @model.set 'name', @ui.object_name.val()
      @model.set 'type', @ui.object_type.val()
      @model.set 'content', @editor.getValue()
      @model.save()
      @ui.savebutton.hide()
      

  class NewWebObjectView extends BaseWebObjectView
    save_object: () ->
      model = new Backbone.Model
        name: @ui.object_name.val()
        type: @ui.object_type.val()
        content: @editor.getValue()

      model.url = @collection.url
        
      console.log 'save me', model
      model.save()
      @ui.savebutton.hide()

      
  #class AceEditObjectView extends BaseEditPageView
  class AceEditObjectView extends Backbone.Marionette.ItemView
    behaviors:
      HasAceEditor: {}
    template: Templates.ace_edit_object

    save_button: '#save-button'
    editorContainer: 'editor'
    editorTheme: 'ace/theme/twilight'
    editorMode: 'ace/mode/markdown'
    contentAttribute: 'content'
    
    editorMode: 'ace/mode/json'

    ui:
      editor: '#editor'
      save_button: '#save-button'
    setup_ace_editor: () ->
      editor = ace.edit @ui.editor

    load_ace_contents: ->
      window.aceview = @
      content = @model.get @contentAttribute
      @editor.setValue JSON.stringify content, null, '\t'

    save_ace_contents: ->
        text_content = @editor.getValue()
        content = JSON.parse text_content
        @model.set @contentAttribute, content
        response = @model.save()
        response.done =>
          # FIXME make a basic method to display alert div
          # or something
          #console.log 'Model successfully saved.'
          #savebutton.hide()
          @ui.save_button.hide()
               
        

  class WebObjectListEntryView extends Backbone.Marionette.ItemView
    template: Templates.object_list_entry
    ui:
      ace_edit_button: '.ace-edit-object'
    events:
      'click @ui.ace_edit_button': 'ace_edit_object'

    show_repo_info: ->
      console.log "Show info for #{@model.id}"

    ace_edit_object: ->
      console.log "Edit object", @model
      url = "#webobjects/aceeditobject/#{@model.id}"
      navigate_to_url url
      
      
  class WebObjectListView extends Backbone.Marionette.CompositeView
    template: Templates.object_list
    childView: WebObjectListEntryView
    childViewContainer: '.listview-list'
      
      
  module.exports =
    SideBarView: SideBarView
    FrontDoorMainView: FrontDoorMainView
    EditWebObjectView: EditWebObjectView
    AceEditObjectView: AceEditObjectView
    NewWebObjectView: NewWebObjectView
    WebObjectListView: WebObjectListView
    
