# modular template loading
define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  tc = require 'teacup'
  marked = require 'marked'
  ft = require 'furniture'
  
  # I use "icon" for font-awesome
  icon = tc.i

  form_group_input_div = ft.templates.forms.form_group_input_div

  { spanbutton
  divbutton
  modal_close_button } = ft.templates.buttons
    
  

  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

    
  ########################################
  # Templates
  ########################################
  git_annex_section = tc.renderable (info) ->
    ga = info.gitannex
    tc.div '.listview-header', ->
      tc.text 'Git Annex DB'
    tc.div '.listview-list', ->
      tc.div '.listview-list-entry', ->
        if not ga?.populated
          tc.span '#populate-gitannex.btn-default.btn-xs', ->
            tc.span style:'color:black', ->
              icon '.fa.fa-pencil'
              tc.text "Populate GitAnnex Database"
        if ga.keys and ga.files and ga.repos
          tc.span '#delete-gitannex.btn-default.btn-xs', ->
            tc.span style:'color:black', ->
              icon '.fa.fa-pencil'
              tc.text "Delete GitAnnex Database"
      for field in ['repos', 'keys', 'files']
        tc.div '.listview-list-entry', ->
          "#{field}: #{ga[field]}"

  siteimages_section = tc.renderable (info) ->
    si = info.siteimages
    tc.div '.listview-header', ->
      tc.text 'Site Images'
    tc.div '.listview-list', ->
      tc.div '.listview-list-entry', ->
        if not si.images
          spanbutton ->
            tc.span style:'color:black', ->
              #icon '.fa.fa-pencil'
              tc.text "No Images in Database"
        else
          spanbutton '#delete-site-images', ->
            tc.span style:'color:black', ->
              icon '.fa.fa-pencil'
              tc.text "Delete Site Images"
      for field in ['images']
        tc.div '.listview-list-entry', ->
          "#{field}: #{si[field]}"

                  
  frontdoor_main = tc.renderable (info) ->
    git_annex_section info
    siteimages_section info
        
    
      

  _fileinput_icon = tc.renderable (name, size='2x') ->
    icon ".fa.fa-#{name}.fa-#{size}"

  fileinput_icon = _fileinput_icon
  
  module.exports =
    frontdoor_main: frontdoor_main
    fileinput_icon: fileinput_icon
    
    
