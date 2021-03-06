define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  
  Models = require 'useradmin/models'
  Templates = require 'useradmin/templates'
  
    
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'useradmin'
  
  BaseSideBarView = ft.views.sidebar
  BaseEditPageView = ft.views.editor
  FormView = ft.views.formview
  
  navigate_to_url = ft.util.navigate_to_url
  
  class FrontDoorMainView extends Backbone.Marionette.ItemView
    template: Templates.frontdoor_main

  class SideBarView extends BaseSideBarView

  class DeleteUserDialog extends Backbone.Marionette.ItemView
    template: Templates.delete_user_dialog
    
  class SimpleUserEntryView extends Backbone.Marionette.ItemView
    template: Templates.simple_user_entry

  class UserListView extends Backbone.Marionette.CompositeView
    template: Templates.simple_user_list
    childView: SimpleUserEntryView
    childViewContainer: '.listview-list'

  class SimpleGroupEntryView extends Backbone.Marionette.ItemView
    template: Templates.simple_group_entry

  class GroupListView extends Backbone.Marionette.CompositeView
    template: Templates.simple_group_list
    childView: SimpleGroupEntryView
    childViewContainer: '.listview-list'
    
  class NewUserFormView extends FormView
    ui:
      name: '[name="name"]'
      password: '[name="password"]'
      confirm: '[name="confirm"]'
      
    template: Templates.new_user_form

    createModel: ->
      new Models.User

    updateModel: ->
      @model.set
        name: @ui.name.val()
        password: @ui.password.val()
        confirm: @ui.confirm.val()
      users = AppChannel.reqres.request 'get-users'
      users.add @model

    onSuccess: (model) ->
      navigate_to_url '#useradmin/listusers'
        
  class NewGroupFormView extends FormView
    template: Templates.new_group_form

    createModel: ->
      new Models.Group
      
  class ViewUserView extends Backbone.Marionette.ItemView
    ui:
      delete_user_button: '.delete-user-button'
      
    events:
      'click @ui.delete_user_button': 'delete_user_pressed'
      #'click .delete-user-button': 'delete_user_pressed'
      #'click .confirm-delete-button': 'confirm_delete_pressed'
    template: Templates.view_user_page
      

    delete_user_pressed: ->
      #console.log 'delete_user_pressed'
      #button = @ui.delete_user_button
      #button.removeClass 'delete-user-button'
      #button.addClass 'confirm-delete-button'
      #button.text 'Confirm'
      view = new DeleteUserDialog
        model: @model
      region = MainChannel.reqres.request 'main:app:get-region', 'modal'
      region.show view
      
    confirm_delete_pressed: ->
      console.log 'confirm_delete_pressed'
      button = $ '.confirm-delete-button'
      @model.destroy()
      content = MainChannel.reqres.request 'main:app:get-region', 'content'
      content.empty()

      
  module.exports =
    FrontDoorMainView: FrontDoorMainView
    SideBarView: SideBarView
    SimpleUserEntryView: SimpleUserEntryView
    UserListView: UserListView
    SimpleGroupEntryView: SimpleGroupEntryView
    GroupListView: GroupListView
    NewUserFormView: NewUserFormView
    NewGroupFormView: NewGroupFormView
    ViewUserView: ViewUserView
    
