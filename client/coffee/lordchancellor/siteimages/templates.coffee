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

    
  ########################################
  # Templates
  ########################################
  frontdoor_main = tc.renderable (page) ->
    tc.raw marked page.content

  image_list_entry = tc.renderable (image) ->
    tc.div '.listview-list-entry', ->
      tc.a href: "#siteimages/showimage/#{image.id}", image.name
      tc.img src: "data:image/jpeg;base64,#{image.thumbnail}"

  new_image_uploader = tc.renderable () ->
    tc.form ->
      form_group_input_div
        input_id: 'input_imagefile'
        label: 'Image File'
        input_attributes:
          name: 'imagefile'
          type: 'file'
          placeholder: 'Select file...'
    
      
  image_list = tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text 'Site Images'
    tc.div '.listview-list'
    tc.div '#new-image-btn.btn.btn-default', 'Upload New Image'
    tc.div '#imageuploader', style:'display: none;', ->
      new_image_uploader()
      
  show_image_view = tc.renderable (page) ->
    tc.div '.listview-header', ->
      tc.text page.name
    tc.div '.listview-list', ->
      tc.raw marked page.content
      
  
  new_image_form = tc.renderable () ->
    form_group_input_div
      input_id: 'input_name'
      label: 'Image Name'
      input_attributes:
        name: 'name'
        placeholder: 'Image Name'
    form_group_input_div
      input_id: 'input_imagefile'
      label: 'Image File'
      input_attributes:
        name: 'imagefile'
        type: 'file'
        placeholder: 'Select file...'
    tc.input '.btn.btn-default.btn-xs', type: 'submit', value: 'Add'

  _fileinput_icon = tc.renderable (name, size='2x') ->
    icon ".fa.fa-#{name}.fa-#{size}"

  fileinput_icon = _fileinput_icon
  
  module.exports =
    frontdoor_main: frontdoor_main
    image_list_entry: image_list_entry
    image_list: image_list
    show_image_view: show_image_view
    new_image_form: new_image_form
    new_image_uploader: new_image_uploader
    fileinput_icon: fileinput_icon
    
    
