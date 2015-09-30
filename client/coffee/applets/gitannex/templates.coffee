# modular template loading
define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  tc = require 'teacup'
  marked = require 'marked'
  
  # I use "icon" for font-awesome
  icon = tc.i

  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

    
  ########################################
  # Templates
  ########################################
  frontdoor_main = tc.renderable (page) ->
    tc.raw marked page.content
    

  show_main_user = tc.renderable (user) ->
    tc.div user.login
    
  user_list_entry = tc.renderable (user) ->
    tc.div '.listview-list-entry', ->
      tc.span '.btn-default.btn-xs', ->
        tc.a href:"#gitannex/edituser/#{user.id}",
        style:'color:black', ->
          icon '.edit-page.fa.fa-pencil'
      tc.text "    " 
      tc.a href:"#gitannex/showuser/#{user.id}", user.login
        
  user_list = tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text 'gitannex users'
    tc.div '.listview-list'

  repo_list_entry = tc.renderable (repo) ->
    window.rrrepo = repo
    local_status_icon = "fa-close"
    if repo.local_repo_exists
      local_status_icon = "fa-check"
    tc.div '.listview-list-entry', ->
      tc.span '.btn-default.btn-xs', ->
        tc.a href:"#gitannex/editrepo/#{repo.id}",
        style:'color:black', ->
          icon ".edit-repo.fa.#{local_status_icon}"
      tc.text "    " 
      tc.a href:"#gitannex/showrepo/#{repo.id}", ->
        tc.text "#{repo.full_name} (#{repo.size} KB)"
        
  repo_list = tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text 'gitannex repos'
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
        
    
  show_annex_info = tc.renderable (info) ->
    tc.div '.listview-header', "Annex Database Info"
    if not info?.populated
      tc.span '#populatedb.btn-default.btn-xs', ->
        tc.span style:'color:black', ->
          icon '.fa.fa-pencil'
          tc.text "Populate Database"
    tc.div '.listview-list', ->
      for att in ['repos', 'keys', 'files']
        tc.div '.listview-list-entry', ->
          tc.text "#{att}: #{info[att]}"
    if info.keys and info.files and info.repos
      tc.span '#deletedb.btn-default.btn-xs', ->
        tc.span style:'color:black', ->
          icon '.fa.fa-pencil'
          tc.text "Delete Database"
    tc.div '.listview-header', "DEBUG Info"
    tc.div '.listview-list', ->
      for att in ['status', 'populated', 'new-job']
        tc.div '.listview-list-entry', ->
          tc.text "#{att}: #{info[att]}"
      

  module.exports =
    frontdoor_main: frontdoor_main
    show_main_user: show_main_user
    user_list_entry: user_list_entry
    user_list: user_list
    repo_list_entry: repo_list_entry
    repo_list: repo_list
    repos_calendar: repos_calendar
    show_repos: show_repos
    show_annex_info: show_annex_info
    
