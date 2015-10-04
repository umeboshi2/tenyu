# modular template loading
define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  tc = require 'teacup'
  marked = require 'marked'
  ft = require 'furniture'
  
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
    tc.raw marked page.content

  # http://goodeggs.github.io/teacup/
  caption = tc.component (selector, attrs, renderContents) ->
    tc.div "#{selector}.caption", renderContents

          

  repo_info_dialog = tc.renderable (repo) ->
    header = tc.renderable (text) ->
      tc.h2 text
    tc.div '.modal-dialog', ->
      tc.div '.modal-content', ->
        header repo.full_name
        tc.div '.modal-body', ->
          #for key, value of repo
          #  tc.div ->
          #    tc.text "#{key}: #{value}"
          repo.url
        tc.div '.modal-footer', ->
          modal_close_button()


  show_main_user = tc.renderable (user) ->
    tc.div user.login
    
  user_list_entry = tc.renderable (user) ->
    tc.div '.listview-list-entry', ->
      spanbutton ->
        tc.a href:"#github/edituser/#{user.id}",
        style:'color:black', ->
          tc.i '.edit-page.fa.fa-pencil'
      tc.a href:"#github/showuser/#{user.id}", user.login
        
  user_list = tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text 'github users'
    tc.div '.listview-list'

  repo_list_entry = tc.renderable (repo) ->
    tc.div '.listview-list-entry', ->
      if not repo.local_repo_exists
        spanbutton '.clone-repo', ->
          tc.i '.fa.fa-download'
        tc.raw "&nbsp;".repeat 5
      tc.span '.center', ->
        tc.text "#{repo.full_name} (#{repo.size} KB)"
      spanbutton ".ghub-repo-info", ->
        tc.i '.fa.fa-info'
      
        
  repo_list = tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text 'github repos'
    tc.div '.listview-list'

  repos_calendar = tc.renderable () ->
    tc.div '.listview-header', 'Repos'
    tc.div '#loading', ->
      tc.h2 'Loading Repos...'
    tc.div '#maincalendar'

  show_repos = tc.renderable (repos) ->
    tc.div '.listview-header', repos.full_name
    tc.div '.listview-list', ->
      for att in ['description', 'fork', 'default_branch',
        'homepage', 'size', 'stargazers_count']
        tc.div '.listview-list-entry', ->
          tc.text "#{att}: #{repos[att]}"
        
    
      
  module.exports =
    frontdoor_main: frontdoor_main
    repo_info_dialog: repo_info_dialog
    show_main_user: show_main_user
    user_list_entry: user_list_entry
    user_list: user_list
    repo_list_entry: repo_list_entry
    repo_list: repo_list
    repos_calendar: repos_calendar
    show_repos: show_repos
    
