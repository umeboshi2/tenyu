conspectus
==========

A basic skeleton for a project serving static resources

create app to serve static resources for website

only client side code and other static resources

index.html is for static sites, otherwise these are static resources for another service

index.local.html is for pre-optimized code

use python and templates (maybe mako) to make generic skeleton

add fontawesome to index page



depends
-------

python

node

compass

grunt


basic structure
----------------

What was "common" is now furniture.  Furniure provides widgets and functions for
making the applications.

Now, common is a place for site-wide code shared between pages.

A site is a collection of pages, each page possibly being a single
page application.

A page is a single page application.  It's usually located at /<page> or
/client/<page>.  A page is an environment for running a set of applets.
Currently, one applet runs in the page at any time.  Also, each applet
currently consists of a sidebar div and a main-content div.  The page
should provide access to each applet intended to be run in that page, usually
by providing a button, menu, or link.


Page
- main
  - configure requirejs paths
  - start application
- application
  - create appmodel
	- appmodel is either static requirement or json from server
  - prepare regions and start backbone history
  - init app routers
  - setup event handlers for managing views in app regions
  - init main page
- msgbus "replaced by Backbone.Wreqr.radio.channel 'global'"
  - MainBus
  - main channel for messages, events, and commands
- models
  - pagewide models
- collections
  - pagewide collections

Applet

- main
  - setup router and routes
  - attach controller to router
- msgbus
  - AppBus for app messages, events, and commands
- models
  - app models
- collections
  - app collections
- templates
  - templates for the views
- views
  - views for the app
- controller
  - controller for app
  - manage views

#Todo

- fix api for site text
- provide site text for guest
- add groups
- add/remove users to/from groups
- remove localstorage and use memory and defaults in code
- create docs on common modules
- use jquery-cookie to set session cookie from server and
  don't refresh page.
- rearrange manner in which bower components are handled
- test using grunt-bower-requirejs
- create a multipage build config with a common stack
  - consider making separate modules for ace and other large libs that are
	only occasionally used.
	
  
setup
---------

using vagrant: vagrant up

using schroot: sudo python scripts/make-webdev-schroot.py

within vagrant or schroot:

- npm install

- bower install

- python scripts/generate-scss.py

- python scripts/prepare-bower-components.py

- http-server

- sensible-browser http://localhost:8080/index.local.html
