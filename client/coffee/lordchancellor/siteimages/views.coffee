define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  tc = require 'teacup'
  
  Masonry = require 'masonry'
  Isotope = require 'isotope'
  imagesLoaded = require 'imagesloaded'

  #behaviors = {}
  #for b of ft.behaviors
  #  behaviors[b] = ft.behaviors[b]
  #window.behaviors = ft.behaviors
  
  Marionette.Behaviors.behaviorsLookup = ->
    ft.behaviors
    
  
  Models = require 'siteimages/models'

  Templates = require 'siteimages/templates'

  # ace requirements
  require 'ace/theme/twilight'
  require 'ace/mode/markdown'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'siteimages'
  
  FormView = ft.views.formview
  { navigate_to_url
    make_json_post } = ft.util
    
  BaseEditPageView = ft.views.editor
  BaseSideBarView = ft.views.sidebar
  
  
  class FrontDoorMainView extends Backbone.Marionette.ItemView
    template: Templates.frontdoor_main

  class SideBarView extends BaseSideBarView

  class SiteImageListEntryView extends Backbone.Marionette.ItemView
    template: Templates.image_list_item
    className: 'image-item'

      
  class SiteImageListView extends Backbone.Marionette.CompositeView
    behaviors:
      PrevNextKeys: {}
      SlideShower: {}
      
    template: Templates.image_list
    childView: SiteImageListEntryView
    childViewContainer: '#images-container'
    ui:
      imagefile: '[name="imagefile"]'
      new_image_button: '#new-image-btn'
      imageuploader: '#imageuploader'
      images: '#images-container'
      
    # handle new page button click
    events:
      'click @ui.new_image_button': 'new_image_button_pressed'
      'fileuploaded @ui.imagefile': 'image_uploaded'

    new_image_button_pressed: (event, data, previewId, index) ->
      #console.log 'new_image_button_pressed'
      #console.log event, data, previewId, index
      @ui.imageuploader.show()
      @ui.new_image_button.hide()

    image_uploaded: (event, data, previewId, index) ->
      #console.log 'image_uploaded'
      #console.log event, data, previewId, index
      response = @collection.fetch()
      response.done =>
        @render()
        
    get_another_page: (direction) ->
      console.log 'get_another_page'
      @ui.images.hide()
      switch direction
        when 'prev' then response = @collection.getPreviousPage()
        when 'next' then response = @collection.getNextPage()
        else response = null
      if response
        response.done =>
          @set_image_layout()

    get_next_page: () ->
      @get_another_page 'next'
      
    get_prev_page: () ->
      @get_another_page 'prev'
        
    handle_key_command: (command) ->
      #console.log "handle_key_command #{command}"
      if command in ['prev', 'next']
        @get_another_page command

    set_image_layout: ->
      items = $ '.image-item'
      imagesLoaded items, =>
        @ui.images.show()
        console.log "Images Loaded>.."
        @masonry.reloadItems()
        @masonry.layout()      

    onDomRefresh: () ->
      @ui.imagefile.fileinput
        uploadUrl: "/rest/v0/main/siteimages/main"
        maxFileCount: 10
        uploadLabel: ''
        uploadIcon: Templates.fileinput_icon 'upload'
        browseLabel: ''
        browseIcon: Templates.fileinput_icon 'bicycle'
        removeLabel: ''
        removeIcon: Templates.fileinput_icon 'remove'
        cancelIcon: Templates.fileinput_icon 'cancel'
      @masonry = new Masonry '#images-container',
        #gutter: 2
        #columnWidth: 130
        columnWidth: 10
        isInitLayout: false
        itemSelector: '.image-item'
      @set_image_layout()

    #onBeforeDestroy: () ->
    #  #console.log "Remove @keydownHandler" + @keydownHandler
    #  $('html').unbind 'keydown', @keydownHandler
    #  @stop_slideshow()
      

      
      
      
  module.exports =
    FrontDoorMainView: FrontDoorMainView
    SideBarView: SideBarView
    SiteImageListView: SiteImageListView
    
