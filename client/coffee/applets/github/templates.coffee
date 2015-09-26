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
        tc.a href:"#github/edituser/#{user.id}",
        style:'color:black', ->
          icon '.edit-page.fa.fa-pencil'
      tc.text "    " 
      tc.a href:"#github/showuser/#{user.id}", user.login
        
  user_list = tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text 'github users'
    tc.div '.listview-list'

  repo_list_entry = tc.renderable (repo) ->
    tc.div '.listview-list-entry', ->
      tc.span '.btn-default.btn-xs', ->
        tc.a href:"#github/editrepo/#{repo.id}",
        style:'color:black', ->
          icon '.edit-page.fa.fa-pencil'
      tc.text "    " 
      tc.a href:"#github/showrepo/#{repo.id}", repo.full_name
        
  repo_list = tc.renderable () ->
    tc.div '.listview-header', ->
      tc.text 'github repos'
    tc.div '.listview-list'

      
  module.exports =
    frontdoor_main: frontdoor_main
    show_main_user: show_main_user
    user_list_entry: user_list_entry
    user_list: user_list
    repo_list_entry: repo_list_entry
    repo_list: repo_list
