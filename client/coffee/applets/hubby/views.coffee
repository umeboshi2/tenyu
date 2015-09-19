define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  require 'jquery-ui'
  ft = require 'furniture'
  
  Templates = require 'hubby/templates'
  Models = require 'hubby/models'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'hubby'
  BaseSideBarView = ft.views.sidebar
  

  { set_get_navbar_color_handlers } = ft.misc.mainpage

  # set the color handlers for the calendar events.
  set_get_navbar_color_handlers MainChannel

  
  class SideBarView extends BaseSideBarView
      
  render_calendar_event = (calEvent, element) ->
    calEvent.url = '#hubby/viewmeeting/' + calEvent.id
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
      
      
    
  class SimpleMeetingView extends Backbone.Marionette.ItemView
    template: Templates.meeting_list_entry
    
  class MeetingListView extends Backbone.Marionette.CollectionView
    childView: SimpleMeetingView

  class MeetingCalendarView extends Backbone.Marionette.ItemView
    template: Templates.meeting_calendar
    ui:
      calendar: '#maincalendar'
      
    keydownHandler: (event_object) =>
      #console.log 'keydownHandler ' + event_object
      window.eo = event_object
      if event_object.keyCode == 65
        @ui.calendar.fullCalendar('prev')
      if event_object.keyCode == 90
        @ui.calendar.fullCalendar('next')
                  
    onDomRefresh: () ->
      $('html').keydown @keydownHandler
      # get the current calendar date that has been stored
      # before creating the calendar
      date  = AppChannel.reqres.request 'maincalendar:get_date'
      navbar_color = MainChannel.reqres.request 'get-navbar-color'
      navbar_bg_color = MainChannel.reqres.request 'get-navbar-bg-color'
      @ui.calendar.fullCalendar
        header:
          left: 'today'
          center: 'title'
          right: 'prev, next'
        theme: true
        defaultView: 'month'
        eventSources:
          [
            url: 'http://hubby.littledebian.org/hubcal'
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
      
  class ShowMeetingView extends Backbone.Marionette.ItemView
    template: Templates.show_meeting_view

    onDomRefresh: () ->
      attachments = $ '.hubby-meeting-item-attachments'
      attachments.hide()
      attachments.draggable()
      $('.hubby-meeting-item-info').click ->
        $(this).next().toggle()
      $('.hubby-meeting-item-attachment-marker').click ->
        $(this).next().toggle()
      $('.hubby-meeting-item-action-marker').click ->
        el = $(this)
        action_area = el.next()
        if el.hasClass('itemaction-loaded')
          action_area.toggle()
        else
          itemid = el.attr('id')
          req = 'item_action_collection'
          collection = AppChannel.reqres.request req, itemid
          response = collection.fetch()
          response.done =>
            html = ''
            for model in collection.models
              html += Templates.short_action model.attributes
            action_area.html html
            $(this).addClass('itemaction-loaded')
        
        
  module.exports =
    SimpleMeetingView: SimpleMeetingView
    MeetingListView: MeetingListView
    MeetingCalendarView: MeetingCalendarView
    ShowMeetingView: ShowMeetingView
    SideBarView: SideBarView
    
    
