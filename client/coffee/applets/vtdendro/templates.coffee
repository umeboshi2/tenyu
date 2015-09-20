# modular template loading
define (require, exports, module) ->
  $ = require 'jquery'
  _ = require 'underscore'
  Backbone = require 'backbone'
  teacup = require 'teacup'
  marked = require 'marked'
  ft = require 'furniture'
  
  renderable = teacup.renderable
  raw = teacup.raw
  
  # I use "icon" for font-awesome
  icon = teacup.i
  text = teacup.text
  # Main Templates must use teacup.
  # The template must be a teacup.renderable, 
  # and accept a layout model as an argument.

  # Tagnames to be used in the template.
  {div, span, link, strong, label, input, img, textarea
  button, a, nav, form, p,
  ul, li, b,
  h1, h2, h3,
  subtitle, section, hr,
  table, tr, td, th, thead
  } = teacup
            
  { form_group_input_div } = ft.templates.forms

  { capitalize } = ft.util
  
  ########################################
  # Templates
  ########################################
  sidebar = renderable (model) ->
    div '.listview-list.btn-group-vertical', ->
      for entry in model.entries
        div '.btn.btn-default.' + entry.name, entry.label
        
  main_vtdendro_view = renderable (model) ->
    p 'main vtdendro view'

  vtdendro_dashboard_view = renderable (model) ->
    p 'vtdendro_dashboard_view'


  blog_dialog_view = renderable (blog) ->
    div '.modal-header', ->
      h2 'This is a modal!'
    div '.modal-body', ->
      p 'here is some content'
    div '.modal-footer', ->
      button '#modal-cancel-button.btn', 'cancel'
      button '#modal-ok-button.btn.btn-default', 'Ok'

  simple_toolbar = renderable (state) ->
    div '.mytoolbar.row', ->
      ul '.pager', ->
        li '.previous', ->
          icon '#prev-page-button.fa.fa-arrow-left.btn.btn-default'
        li '.next', ->
          icon '#next-page-button.fa.fa-arrow-right.btn.btn-default'
        li '.total-records', "Total: #{state?.totalRecords}"
        li '.page-number', "Page #{state?.currentPage}"
        
  simple_genus_list = renderable (state) ->
    simple_toolbar(state)
    div ->
      div '#genuslist-container.listview-list'

  simple_genus_info = renderable (genus) ->
    div '.genus.listview-list-entry', ->
      a href:"#vtdendro/viewgenus/#{genus.name}", genus.name

  simple_vtspecies_info = renderable (species) ->
    div '.species.listview-list-entry', ->
      a href:"#vtdendro/viewvtspecies/#{species.id}", species.cname

  simple_vtspecies_list = renderable () ->
    simple_toolbar()
    div '#total-records'
    div ->
      div '#speclist-container.listview-list'

  vtspecies_genus_list = renderable (state) ->
    simple_toolbar()
    div '.listview-header', ->
      text "Genus: #{state.genus.name}"
      span ->
        raw "&nbsp;("
      span '#total-records', ->
        text 'total'
      raw ")"
    div ->
      div '#speclist-container.listview-list'
      div '.listview-list-entry', ->
        raw state.genus.wikipage

  simple_wikipage_info = renderable (model) ->
    div '.wikipage.listview-list-entry', ->
      a href:"#vtdendro/wikipage/#{model.name}", model.name

  wikipage_list = renderable () ->
    simple_toolbar()
    div '#total-records'
    div ->
      div '#wikipage-container.listview-list'

    
      
  wikipage_view = renderable (wikipage) ->
    div '.listview-list-entry', ->
      raw wikipage.content
      
  vtspecies_full_view = renderable (spec) ->
    window.spec = spec
    div '.listview-header', spec.cname
    div '.listview-list-entry', ->
      a href: "#vtdendro/viewgenus/#{spec.genus}", "#{spec.genus} #{spec.species}"
    if spec.looklikes.length
      div '.listview-list-entry', ->
        span 'Looks like:'
        for looklike in spec.looklikes
          span '.btn.btn-default.btn-xs', ->
            a href:"#vtdendro/viewvtspecies/#{looklike.id}", looklike.cname
        
    table ->
      for field in ['form', 'leaf', 'bark', 'fruit', 'flower', 'twig']
        if field of spec
          tr '.listview-list-entry',  ->
            td ->
              if field of spec.pictures
                img src:"#{spec.pictures[field].localurl}", width:100,
            td ->
              strong "#{field}:  "
              text spec[field]
      if spec.pictures and 'map' of spec.pictures
        tr '.listview-list-entry', ->
          td colspan:2, ->
            img src:"#{spec.pictures.map.localurl}"
      else
        tr '.listview-list-entry', ->
          td ->
            text "No map available for #{spec.cname}"
      tr '.listview-header', ->
        td colspan:2, ->
          text 'Wikipedia'
      tr '.listview-list-entry', ->
       td colspan:2, ->
        raw spec.wikipage

  search_vtspecies_form = renderable (params) ->
    form_group_input_div
      input_id: 'input_cname'
      label: 'Common Name'
      input_attributes:
        name: 'cname'
        placeholder: ''
        value: params.cname
    for field in ['form', 'leaf', 'bark', 'fruit', 'flower', 'twig']
      form_group_input_div
        input_id: "input_#{field}"
        label: capitalize field
        input_attributes:
          name: field
          placeholder: ''
          value: params[field]
    input '.btn.btn-default.btn-xs', type:'submit', value:'HelloThere'
        
            
          
  simple_post_view = renderable (post) ->
    div '.listview-list-entry', ->
      #p ->
      # a href:post.post_url, target:'_blank', post.blog_name
      span ->
        #for photo in post.photos
        photo = post.photos[0]
        current_width = 0
        current_size = null
        for size in photo.alt_sizes
          if size.width > current_width and size.width < 250
            current_size = size
            current_width = size.width
        size = current_size 
        a href:post.post_url, target:'_blank', ->
          img src:size.url

  module.exports =
    sidebar: sidebar
    main_vtdendro_view: main_vtdendro_view
    vtdendro_dashboard_view: vtdendro_dashboard_view
    blog_dialog_view: blog_dialog_view
    simple_genus_list: simple_genus_list
    simple_genus_info: simple_genus_info
    simple_vtspecies_list: simple_vtspecies_list
    simple_vtspecies_info: simple_vtspecies_info
    vtspecies_full_view: vtspecies_full_view
    search_vtspecies_form: search_vtspecies_form
    vtspecies_genus_list: vtspecies_genus_list
    wikipage_view: wikipage_view
    simple_wikipage_info: simple_wikipage_info
    wikipage_list: wikipage_list
    
