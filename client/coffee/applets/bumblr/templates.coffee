# modular template loading
define (require, exports, module) ->
  tc = require 'teacup'
  ft = require 'furniture'
  { form_group_input_div } = ft.templates.forms
  # I use "icon" for font-awesome
  icon = tc.i
  
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
        
  main_bumblr_view = tc.renderable (model) ->
    tc.p 'main bumblr view'

  bumblr_dashboard_view = tc.renderable (model) ->
    tc.p 'bumblr_dashboard_view'


  blog_dialog_view = tc.renderable (blog) ->
    tc.div '.modal-header', ->
      tc.h2 'This is a modal!'
    tc.div '.modal-body', ->
      tc.p 'here is some content'
    tc.div '.modal-footer', ->
      tc.button '#modal-cancel-button.btn', 'cancel'
      tc.button '#modal-ok-button.btn.btn-default', 'Ok'


  simple_blog_list = tc.renderable () ->
    tc.div ->
      tc.a '.btn.btn-default', href:'#bumblr/addblog', "Add blog"
      tc.div '#bloglist-container.listview-list'
      
  simple_blog_info = tc.renderable (blog) ->
    tc.div '.blog.listview-list-entry', ->
      tc.a href:'#bumblr/viewblog/' + blog.name, blog.name
      icon ".delete-blog-button.fa.fa-close.btn.btn-default.btn-xs",
      blog:blog.name

  page_size_input_div = tc.renderable () ->
    tc.div '#page-size-input-div', ->
      form_group_input_div
        input_id: 'input_pagesize'
        label: 'Page Size'
        input_attributes:
          name: 'pagesize'
          placeholder: ''
          value: 10
    
      
  simple_post_page_view = tc.renderable () ->
    tc.div '.mytoolbar.row', ->
      tc.ul '.pager', ->
        tc.li '.previous', ->
          icon '#prev-page-button.fa.fa-arrow-left.btn.btn-default'
        tc.li ->
          icon '#slideshow-button.fa.fa-play.btn.btn-default'
        tc.li '.next', ->
          icon '#next-page-button.fa.fa-arrow-right.btn.btn-default'
    tc.div '#posts-container.row'
      
  simple_post_view = tc.renderable (post) ->
    window.thispost = post
    tc.div '.listview-list-entry', ->
      #p ->
      # a href:post.post_url, target:'_blank', post.blog_name
      tc.span ->
        #for photo in post.photos
        photo = post.photos[0]
        current_width = 0
        current_size = null
        for size in photo.alt_sizes
          #if size.width > current_width and size.width < post.target_width
          if size.width > current_width and size.width < 300
            current_size = size
            current_width = size.width
        size = current_size
        window.ttsize = size
        tc.a href:post.post_url, target:'_blank', ->
          tc.img src:size.url

  new_blog_form_view = tc.renderable (model) ->
    form_group_input_div
      input_id: 'input_blogname'
      label: 'Blog Name'
      input_attributes:
        name: 'blog_name'
        placeholder: ''
        value: 'dutch-and-flemish-painters'
    tc.input '.btn.btn-default.btn-xs', type:'submit', value:'Add Blog'
        
  consumer_key_form = tc.renderable (settings) ->
    form_group_input_div
      input_id: 'input_key'
      label: 'Consumer Key'
      input_attributes:
        name: 'consumer_key'
        placeholder: ''
        value: settings.consumer_key
    form_group_input_div
      input_id: 'input_secret'
      label: 'Consumer Secret'
      input_attributes:
        name: 'consumer_secret'
        placeholder: ''
        value: settings.consumer_secret
    form_group_input_div
      input_id: 'input_token'
      label: 'Token'
      input_attributes:
        name: 'token'
        placeholder: ''
        value: settings.token
    form_group_input_div
      input_id: 'input_tsecret'
      label: 'Token Secret'
      input_attributes:
        name: 'token_secret'
        placeholder: ''
        value: settings.token_secret
    tc.input '.btn.btn-default.btn-xs', type:'submit', value:'Submit'
    
              
  module.exports =
    sidebar: sidebar
    main_bumblr_view: main_bumblr_view
    bumblr_dashboard_view: bumblr_dashboard_view
    blog_dialog_view: blog_dialog_view
    simple_blog_list: simple_blog_list
    simple_blog_info: simple_blog_info
    simple_post_view: simple_post_view
    simple_post_page_view: simple_post_page_view
    new_blog_form_view: new_blog_form_view
    consumer_key_form: consumer_key_form
    
    
