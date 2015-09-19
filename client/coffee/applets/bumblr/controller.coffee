define (require, exports, module) ->
  $ = require 'jquery'
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  fullCalendar = require 'fullcalendar'
  ft = require 'furniture'

  Views = require 'bumblr/views'
  Models = require 'bumblr/models'
  Collections = require 'bumblr/collections'

  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'bumblr'
  
  Util = ft.util
  

  { SideBarController } = ft.controllers.sidebar

  side_bar_data = new Backbone.Model
    entries: [
      {
        name: 'List Blogs'
        url: '#bumblr/listblogs'
      }
      {
        name: 'Settings'
        url: '#bumblr/settings'
      }
      ]

  credentials = AppChannel.reqres.request 'get_app_settings'
  api_key = credentials.get 'consumer_key'
  #console.log 'api_key is -> ' + api_key
  
  class Controller extends SideBarController
    sidebarclass: Views.SideBarView
    sidebar_model: side_bar_data
    
    init_page: ->
      #console.log 'init_page', @App
      view = new Views.BlogModal()
      modal = MainChannel.reqres.request 'main:app:get-region', 'modal'
      modal.show view
      
    set_header: (title) ->
      header = $ '#header'
      header.text title
      
    start: ->
      content = MainChannel.reqres.request 'main:app:get-region', 'content'
      sidebar = MainChannel.reqres.request 'main:app:get-region', 'sidebar'
      if content.hasView()
        #console.log 'empty content....'
        content.empty()
      if sidebar.hasView()
        console.log 'empty sidebar....'
        sidebar.empty()
      @set_header 'Bumblr'
      @list_blogs()
      
    show_mainview: () ->
      @make_sidebar()
      view = new Views.MainBumblrView
      @_show_content view
      Util.scroll_top_fast()
      

    show_dashboard: () ->
      @make_sidebar()
      view = new Views.BumblrDashboardView
      @_show_content view
      Util.scroll_top_fast()
        
    list_blogs: () ->
      #console.log 'list_blogs called;'
      @make_sidebar()
      blogs = AppChannel.reqres.request 'get_local_blogs'
      view = new Views.SimpleBlogListView
        collection: blogs
      @_show_content view
      Util.scroll_top_fast()
      
      
    view_blog: (blog_id) ->
      #console.log 'view blog called for ' + blog_id
      @make_sidebar()
      make_collection = 'make_blog_post_collection'
      base_hostname = blog_id + '.tumblr.com'
      collection = AppChannel.reqres.request make_collection, base_hostname
      response = collection.fetch()
      response.done =>
        view = new Views.BlogPostListView
          collection: collection
        @_show_content view
        Util.scroll_top_fast()

    add_new_blog: () ->
      #console.log 'add_new_blog called'
      @make_sidebar()
      view = new Views.NewBlogFormView
      @_show_content view
      Util.scroll_top_fast()
            
    settings_page: () ->
      console.log 'Settings page.....'
      settings = AppChannel.reqres.request 'get_app_settings'
      view = new Views.ConsumerKeyFormView model:settings
      window.setttingsview = view
      @_show_content view
      Util.scroll_top_fast()
      
  module.exports = Controller
  
