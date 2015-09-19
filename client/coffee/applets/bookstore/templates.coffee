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
    
  book_view = tc.renderable (model) ->
    tc.img '.book.item', src:model.thumbnail, alt:""

  bookstore_layout = tc.renderable () ->
    tc.div '#searchBar', ->
      tc.text 'Search : '
      tc.input '#searchTerm.form-control', type:'text', name:'search',
      autocomplete:'off', value:''
      icon '#spinner.fa.fa-spinner.fa-spin'
    tc.div '#bookContainer'

  booklist_view = tc.renderable () ->
    icon_button = '.btn.btn-default.btn-sm.fa'
    tc.div style:'display:table;width:100%;height:100%;', ->
      tc.div '.toolbar', ->
        icon "#{icon_button}.fa-arrow-left.pull-left"
        icon "#{icon_button}.fa-arrow-right.pull-right"
      tc.div '.books'

  book_detail_view = tc.renderable (book) ->
    tc.a '#close-dialog.close', dataDissmiss:'modal', 'x'
    tc.div '.imgBook', ->
      tc.img src:book.thumbnail
    tc.h1 book.title
    subtitle = if book?.subtitle then tc.h2 book.subtitle else null
    description = if book?.description then tc.p book.description else null
    href = "http://books.google.com/books?id=#{book.googleId}"
    subtitle
    description
    tc.b 'Google link'
    tc.a href:href, target:'_blank', href
    
    

  module.exports =
    frontdoor_main: frontdoor_main
    book_view: book_view
    bookstore_layout: bookstore_layout
    booklist_view: booklist_view
    book_detail_view: book_detail_view
    
    
    
