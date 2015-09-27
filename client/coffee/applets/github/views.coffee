define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  
  Models = require 'github/models'

  Templates = require 'github/templates'

  # ace requirements
  require 'ace/theme/twilight'
  require 'ace/mode/markdown'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'github'
  
  FormView = ft.views.formview
  { navigate_to_url } = ft.util
    
  BaseEditPageView = ft.views.editor
  BaseSideBarView = ft.views.sidebar
  

  # calendar helpers
  render_calendar_event = (calEvent, element) ->
    calEvent.url = "#github/showrepo/#{calEvent.id}"
    element.css
      'font-size' : '0.9em'
      
  calendar_view_render = (view, element) ->
    AppChannel.reqres.request 'maincalendar:set_date'

  loading_calendar_events = (bool) ->
    loading = $ '#loading'
    toolbar = $ '.fc-toolbar'
    if bool
      loading.show()
      toolbar.hide()
    else
      loading.hide()
      toolbar.show()
      
      

  
  
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

  class RepoCalendarView extends Backbone.Marionette.ItemView
    template: Templates.repos_calendar
    ui:
      calendar: '#maincalendar'
    keyCodes:
      prev:65
      next: 90
    
    keydownHandler: (event_object) =>
      #console.log 'keydownHandler ' + event_object
      window.eo = event_object
      if event_object.keyCode == @keyCodes.prev
        @ui.calendar.fullCalendar('prev')
      if event_object.keyCode == @keyCodes.next
        @ui.calendar.fullCalendar('next')
                  
    onDomRefresh: () ->
      # set key handlers
      $('html').keydown @keydownHandler
      # get the current calendar date that has been stored
      # before creating the calendar
      date  = AppChannel.reqres.request 'maincalendar:get_date'
      navbar_color = MainChannel.reqres.request 'get-navbar-color'
      navbar_bg_color = MainChannel.reqres.request 'get-navbar-bg-color'
      @ui.calendar.fullCalendar
        header:
          left: 'today, agendaDay, agendaWeek, month'
          center: 'title'
          right: 'prev, next'
        theme: true
        defaultView: 'month'
        eventSources:
          [
            url: '/rest/v0/main/ghub/repocalendar'
          ]
        eventRender: render_calendar_event
        viewRender: calendar_view_render
        loading: loading_calendar_events
        eventColor: navbar_bg_color
        eventTextColor: navbar_color
        eventClick: (event) ->
          url = event.url
          Backbone.history.navigate url, trigger: true
      # if the current calendar date that has been set,
      # go to that date
      if date != undefined
        @ui.calendar.fullCalendar('gotoDate', date)
        
    onBeforeDestroy: () ->
      #console.log "Remove @keydownHandler" + @keydownHandler
      $('html').unbind 'keydown', @keydownHandler
      
      
  class ShowReposView extends Backbone.Marionette.ItemView
    template: Templates.show_repos
  
  module.exports =
    FrontDoorMainView: FrontDoorMainView
    SideBarView: SideBarView
    PageListView: PageListView
    UserListView: UserListView
    RepoListView: RepoListView
    RepoCalendarView: RepoCalendarView
    ShowReposView: ShowReposView
  
