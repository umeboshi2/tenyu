define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  
  Models = require 'github/models'

  Templates = require 'github/templates'

  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'github'
  
  FormView = ft.views.formview
  { navigate_to_url
    make_json_post } = ft.util
    
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
      
      

  notify_task_complete = (task_id) ->
    check_task_one = () ->
      response = null
      
  
  class SideBarView extends BaseSideBarView
    
  class FrontDoorMainView extends Backbone.Marionette.ItemView
    template: Templates.frontdoor_main

  class ModalView extends Backbone.Marionette.ItemView
    template: Templates.repo_info_dialog
    onDomRefresh: () ->
      #console.log "show modal....."
      #$('#modal').modal 'show'
      
    
  class UserListEntryView extends Backbone.Marionette.ItemView
    template: Templates.user_list_entry
    
  class UserListView extends Backbone.Marionette.CompositeView
    template: Templates.user_list
    childView: UserListEntryView
    childViewContainer: '.listview-list'
    

  class RepoListEntryView extends Backbone.Marionette.ItemView
    template: Templates.repo_list_entry
    ui:
      info_button: '.ghub-repo-info'
      clone_button: '.clone-repo'
      
    events: ->
      'click @ui.info_button': 'show_repo_info'
      'click @ui.clone_button': 'clone_repo'

    clone_repo: ->
      console.log "Clone_Repo for #{@model.id}"
      console.log @model
      response = @model.save
        action: 'clone-repo'
      response.done =>
        console.log "Task ID", @model.get('task_id')
        
    show_repo_info: ->
      #console.log "Show info for #{@model.id}"
      view = new ModalView
        model: @model
      modal_region = MainChannel.reqres.request 'main:app:get-region', 'modal'
      modal_region.show view
      #modal_region.showModal view

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
    ModalView: ModalView
    SideBarView: SideBarView
    UserListView: UserListView
    RepoListView: RepoListView
    RepoCalendarView: RepoCalendarView
    ShowReposView: ShowReposView
  
