define (require, exports, module) ->
  Backbone = require 'backbone'
  Marionette = require 'marionette'
  ft = require 'furniture'
  tc = require 'teacup'
  
  
  Models = require 'webobjects/models'

  Templates = require 'webobjects/templates'

  # ace requirements
  require 'ace/theme/twilight'
  require 'ace/mode/markdown'
  
  MainChannel = Backbone.Wreqr.radio.channel 'global'
  AppChannel = Backbone.Wreqr.radio.channel 'webobjects'
  
  FormView = ft.views.formview
  { navigate_to_url
    make_json_post } = ft.util
    
  BaseEditPageView = ft.views.editor
  BaseSideBarView = ft.views.sidebar
  

  
  
  class FrontDoorMainView extends Backbone.Marionette.ItemView
    template: Templates.frontdoor_main

  class SideBarView extends BaseSideBarView

  class SiteImageListEntryView extends Backbone.Marionette.ItemView
    template: Templates.image_list_entry

      
  class SiteImageListView extends Backbone.Marionette.CompositeView
    template: Templates.image_list
    childView: SiteImageListEntryView
    childViewContainer: '.listview-list'
    ui:
      imagefile: '[name="imagefile"]'
      new_image_button: '#new-image-btn'
      imageuploader: '#imageuploader'
      
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
      
    onDomRefresh: () ->
      @ui.imagefile.fileinput
        uploadUrl: "/rest/v0/main/webobjects/main"
        uploadLabel: ''
        uploadIcon: Templates.fileinput_icon 'upload'
        browseLabel: ''
        browseIcon: Templates.fileinput_icon 'bicycle'
        removeLabel: ''
        removeIcon: Templates.fileinput_icon 'remove'
        cancelIcon: Templates.fileinput_icon 'cancel'


#$('#input-id').on('fileuploaded', function(event, data, previewId, index) {
#    var form = data.form, files = data.files, extra = data.extra, 
#        response = data.response, reader = data.reader;
#    console.log('File uploaded triggered');
#});        
      
      
  class NewSiteImageFormView extends Backbone.Marionette.ItemView
    ui:
      #name: '[name="name"]'
      imagefile: '[name="imagefile"]'

    template: Templates.new_image_uploader
      
    onDomRefresh: () ->
      @ui.imagefile.fileinput
        uploadUrl: "/rest/v0/main/webobjects/main"
      
      
      
  module.exports =
    FrontDoorMainView: FrontDoorMainView
    SideBarView: SideBarView
    SiteImageListView: SiteImageListView
    NewSiteImageFormView: NewSiteImageFormView
    
