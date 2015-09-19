# modular template loading
define (require, exports, module) ->
  tc = require 'teacup'
  marked = require 'marked'
  ft = require 'furniture'
  
  # I use "icon" for font-awesome
  icon = tc.i
  
  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

  form_group_input_div = ft.templates.forms.form_group_input_div
  
  ########################################
  # Templates
  ########################################
  page_list_entry = tc.renderable (page) ->
    tc.div '.listview-list-entry', ->
      tc.span '.btn-default.btn-xs', ->
        tc.a href:"#sitetext/editpage/#{page.name}",
        style:'color:black', ->
          icon '.edit-page.fa.fa-pencil'
      tc.text "    "
      tc.a href:"#sitetext/showpage/#{page.name}", page.name
        
      
  page_list = tc.renderable () ->
    tc.div '.listview-header', 'Wiki Pages'
    tc.div '.listview-list'

  page_view = tc.renderable (page) ->
    tc.div '.listview-header', ->
      tc.text page.name
    tc.div '.listview-list', ->
      tc.raw marked page?.content
      
  edit_page = tc.renderable (page) ->
    tc.div '.listview-header', ->
      tc.text "Editing #{page.name}"
      tc.div '#save-button.pull-left.btn.btn-default.btn-xs', ->
        tc.text 'save'
    tc.div '#editor'
    

  new_page_form = tc.renderable () ->
    form_group_input_div
      input_id: 'input_name'
      label: 'Page Name'
      input_attributes:
        name: 'name'
        placeholder: 'New Page'
    form_group_input_div
      input_id: 'input_content'
      input_type: tc.textarea
      label: 'Content'
      input_attributes:
        name: 'content'
        placeholder: '...add some text....'
    tc.input '.btn.btn-default.btn-xs', type:'submit', value:'Add Page'
        
  module.exports =
    page_list_entry: page_list_entry
    page_list: page_list
    page_view: page_view
    edit_page: edit_page
    new_page_form: new_page_form
    
    
