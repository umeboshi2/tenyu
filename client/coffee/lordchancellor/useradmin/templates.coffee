# modular template loading
define (require, exports, module) ->
  tc = require 'teacup'
  ft = require 'furniture'
  
  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

  { form_group_input_div } = ft.templates.forms
      
  ########################################
  # Templates
  ########################################
  simple_user_entry = tc.renderable (model) ->
    tc.div '.listview-list-entry', ->
      tc.a href:'#useradmin/viewuser/' + model.id, model.name

  simple_group_entry = tc.renderable (model) ->
    tc.div '.listview-list-entry', ->
      tc.a href:'#useradmin/viewgroup/' + model.id, model.name

  simple_user_list = tc.renderable (users) ->
    tc.div '.listview-header', 'Users'
    tc.div '.listview-list'
    
  simple_group_list = tc.renderable (groups) ->
    tc.div '.listview-header', 'Groups'
    tc.div '.listview-list'


  view_user_page = tc.renderable (model) ->
    tc.div ->
      tc.div '.listview-header', model.name
      tc.p ->
        tc.text "This is the user page for #{model.name}"
      tc.hr
      tc.div '.btn.btn-default.delete-user-button', 'Delete User'


  new_user_form = tc.renderable () ->
    form_group_input_div
      input_id: 'input_name'
      label: 'User Name'
      input_attributes:
        name: 'name'
        placeholder: 'User Name'
    form_group_input_div
      input_id: 'input_password'
      label: 'Password'
      input_attributes:
        name: 'password'
        type: 'password'
        placeholder: 'Enter password'
    form_group_input_div
      input_id: 'input_confirm'
      label: 'Confirm Password'
      input_attributes:
        name: 'confirm'
        type: 'password'
        placeholder: 'Confirm your password'
    tc.input '.btn.btn-default.btn-xs', type:'submit', value:"Add New User"
      
  new_group_form = tc.renderable () ->
    form_group_input_div
      input_id: 'input_name'
      label: 'Group Name'
      input_attributes:
        name: 'name'
        placeholder: 'Enter group name'
    tc.input '.btn.btn-default.btn-xs', type:'submit', value:"Add New Group"

    
         
  module.exports =
    simple_user_entry: simple_user_entry
    simple_group_entry: simple_group_entry
    simple_user_list: simple_user_list
    simple_group_list: simple_group_list
    new_user_form: new_user_form
    new_group_form: new_group_form
    view_user_page: view_user_page
    
