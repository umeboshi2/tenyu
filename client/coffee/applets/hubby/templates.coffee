# modular template loading
define (require, exports, module) ->
  tc = require 'teacup'
  marked = require 'marked'
  ft = require 'furniture'
  
  { capitalize
    handle_newlines } = ft.util


  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

  ########################################
  # Templates
  ########################################
  sidebar = tc.renderable (model) ->
    tc.div '.listview-list.btn-group-vertical', ->
      for entry in model.entries
        tc.div '.btn.btn-default.' + entry.name, entry.label
        
  short_action = tc.renderable (action) ->
    tc.div '.hubby-short-action', ->
      tc.p 'Mover(fixme): ' + action.mover_id
      tc.p 'Seconder(fixme): ' + action.seconder_id
      tc.p '.hubby-action-text', ->
        tc.raw handle_newlines action.action_text
      
  action_list = tc.renderable () ->
    tc.div '.listview-header', 'Actions'
    tc.div '.listview-list'
    
  meeting_list_entry = tc.renderable (meeting) ->
    tc.div '.listview-list-entry', ->
      tc.a href:'#hubby/viewmeeting/' + meeting.id, ->
        tc.text meeting.title
        
  meeting_list = tc.renderable () ->
    tc.div '.listview-header', 'Meetings'
    tc.div '.listview-list'
    
  meeting_calendar = tc.renderable () ->
    tc.div '.listview-header', 'Meetings'
    tc.div '#loading', ->
      tc.h2 'Loading Meetings'
    tc.div '#maincalendar'

  show_meeting_view = tc.renderable (meeting) ->
    tc.div '.hubby-meeting-header', ->
      tc.p ->
        tc.text 'Department: ' + meeting.dept
      tc.p ->
        tc.text 'Meeting held ' + meeting.prettydate
      tc.div '.hubby-meeting-header-agenda', ->
        tc.text 'Agenda: ' + meeting.agenda_status
      tc.div '.hubby-meeting-header-minutes', ->
        tc.text 'Minutes: ' + meeting.minutes_status
    tc.div '.hubby-meeting-item-list', ->
      agenda_section = 'start'
      item_count = 0
      meeting_items = meeting.meeting_items
      if meeting_items == undefined
        meeting_items = []
      for mitem in meeting_items
        item_count += 1
        item = meeting.items[mitem.item_id]
        #console.log agenda_section + '->' + mitem.type
        if mitem.type != agenda_section and mitem.type
          agenda_section = mitem.type
          section_header = capitalize agenda_section + ' Agenda'
          tc.h3 '.hubby-meeting-agenda-header', section_header
        tc.div '.hubby-meeting-item', ->
          tc.div '.hubby-meeting-item-info', ->
            agenda_num = mitem.agenda_num
            if agenda_num is null
              agenda_num = item_count
            tc.div '.hubby-meeting-item-agenda-num', agenda_num
            tc.div '.hubby-meeting-item-fileid', item.file_id
            tc.div '.hubby-meeting-item-status', item.status
          tc.div '.hubby-meeting-item-content', ->
            tc.p '.hubby-meeting-item-text', item.title
            if item.attachments != undefined and item.attachments.length
              tc.div '.hubby-meeting-item-attachment-marker', 'Attachments'
              tc.div '.hubby-meeting-item-attachments', ->
                for att in item.attachments
                  tc.div ->
                    tc.a href:att.url, att.name
            if item.actions != undefined and item.actions.length
              tc.div '#' + item.id + '.hubby-meeting-item-action-marker', ->
                tc.text 'Actions'
              tc.div '#hubby-meeting-item-actions-' + item.id

  show_meeting_item = (mitem, item, item_count) ->
    tc.div '.hubby-meeting-item', ->
      tc.div '.hubby-meeting-item-info', ->
        agenda_num = mitem.agenda_num
        if agenda_num is null
          agenda_num = item_count
        tc.div '.hubby-meeting-item-agenda-num', agenda_num
        tc.div '.hubby-meeting-item-fileid', item.file_id
        tc.div '.hubby-meeting-item-status', item.status
      tc.div '.hubby-meeting-item-content', ->
        tc.p '.hubby-meeting-item-text', item.title
                                                          
              
  module.exports =
    sidebar: sidebar
    short_action: short_action
    action_list: action_list
    meeting_list_entry: meeting_list_entry
    meeting_list: meeting_list
    meeting_calendar: meeting_calendar
    show_meeting_view: show_meeting_view
    
