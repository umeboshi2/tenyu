define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  
  Models = require 'github/models'

  Templates = require 'github/templates'

  # ace requirements
  require 'ace/theme/twilight'
  require 'ace/mode/markdown'
  
  AppChannel = Backbone.Wreqr.radio.channel 'github'
  
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
      navigate_to_url '#github/addpage'

  class UserListEntryView extends Backbone.Marionette.ItemView
    template: Templates.user_list_entry
    
  class UserListView extends Backbone.Marionette.CompositeView
    template: Templates.user_list
    childView: UserListEntryView
    childViewContainer: '.listview-list'
    

  class RepoListEntryView extends Backbone.Marionette.ItemView
    template: Templates.repo_list_entry

  class RepoListView extends Backbone.Marionette.CompositeView
    template: Templates.repo_list
    childView: RepoListEntryView
    childViewContainer: '.listview-list'
    
  module.exports =
    FrontDoorMainView: FrontDoorMainView
    SideBarView: SideBarView
    PageListView: PageListView
    UserListView: UserListView
    RepoListView: RepoListView
    
