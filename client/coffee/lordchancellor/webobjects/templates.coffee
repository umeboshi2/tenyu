# modular template loading
define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  tc = require 'teacup'
  marked = require 'marked'
  ft = require 'furniture'
  
  # I use "icon" for font-awesome
  icon = tc.i

  form_group_input_div = ft.templates.forms.form_group_input_div
  

  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

  { spanbutton
  divbutton
  modal_close_button } = ft.templates.buttons
    
    
  ########################################
  # Templates
  ########################################
  frontdoor_main = tc.renderable (page) ->
    tc.div '#editor'

  edit_webobject_main = tc.renderable (object) ->
    tc.div '.listview-header', ->
      tc.text "Editing #{object.name}"
    tc.div '#save-button.btn.btn-default.btn-xs', ->
      tc.text 'save'
    form_group_input_div
      input_id: 'object_name'
      label: 'Object Name'
      input_attributes:
        name: 'name'
        placeholder: 'New Object'
        value: object.name
    form_group_input_div
      input_id: 'object_type'
      label: "Object Type"
      input_attributes:
        name: 'type'
        placeholder: 'appmodel'
        value: object.type
    tc.div '#alert'
    tc.div '#editor'
    
  edit_webobject = tc.renderable (object) ->
    tc.div '.listview-header', ->
      tc.text "Editing #{object.name}"
    tc.div '#save-button.btn.btn-default.btn-xs', ->
      tc.text 'save'
    form_group_input_div
      input_id: 'object_name'
      label: 'Object Name'
      input_attributes:
        name: 'name'
        placeholder: 'New Object'
        value: object.name
    form_group_input_div
      input_id: 'object_type'
      label: "Object Type"
      input_attributes:
        name: 'type'
        placeholder: 'appmodel'
        value: object.type
    tc.div '#alert'
    tc.div '#editor'

  ace_edit_object = tc.renderable (object) ->
    tc.div '.listview-header', ->
      tc.text "Editing #{object.name}"
    tc.div '#save-button.btn.btn-default.btn-xs', ->
      tc.text 'save'
    tc.div '#editor'
    

  object_list_entry = tc.renderable (object) ->
    tc.div '.listview-list-entry', ->
      tc.a href: "#webobjects/editobject/#{object.id}", object.name
      spanbutton ".ace-edit-object", ->
        tc.i '.fa.fa-pencil'
      
  object_list = tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text 'Site Objects'
    tc.div '.listview-list'
    #tc.div '#new-object-btn.btn.btn-default', 'Upload New Object'
    divbutton "#new-object-btn", "Upload New Object"
     
  show_object_view = tc.renderable (page) ->
    tc.div '.listview-header', ->
      tc.text page.name
    tc.div '.listview-list', ->
      tc.raw marked page.content
      
  simple_alert = tc.renderable (message) ->
    tc.div '.alert.alert-success.alert-dismissable', message
    
  module.exports =
    frontdoor_main: frontdoor_main
    edit_webobject: edit_webobject
    ace_edit_object: ace_edit_object
    object_list_entry: object_list_entry
    object_list: object_list
    show_object_view: show_object_view
    simple_alert: simple_alert
    
