import os
from ConfigParser import ConfigParser
from datetime import datetime
from urllib2 import HTTPError

from cornice.resource import resource, view
from pyramid.httpexceptions import HTTPNotFound
from pyramid.httpexceptions import HTTPFound
from pyramid.httpexceptions import HTTPForbidden
from bs4 import BeautifulSoup

from trumpet.views.rest.base import BaseResource

from tenyu.managers.ghub import GHRepoManager, GHUserManager


from tenyu.views.rest import APIROOT
        

rscroot = os.path.join(APIROOT, 'main', 'ghub')
users_path = os.path.join(rscroot, 'users')
repos_path = os.path.join(rscroot, 'repos')

@resource(collection_path=users_path,
          path=os.path.join(users_path, '{id}'))
class GHUserView(BaseResource):
    def __init__(self, request):
        super(GHUserView, self).__init__(request)
        settings = request.registry.settings
        user_id = int(settings['default.github.user_id'])
        self.mgr = GHUserManager(request.db, user_id)
        
    def collection_query(self):
        return self.mgr.query()

    def get(self):
        id = self.request.matchdict['id']
        if id == 'main':
            id = self.user_id
        o = self.mgr.get(id)
        return o.serialize()
    
@resource(collection_path=repos_path,
          path=os.path.join(repos_path, '{id}'))
class GHRepoView(BaseResource):
    def __init__(self, request):
        super(GHRepoView, self).__init__(request)
        settings = request.registry.settings
        user_id = int(settings['default.github.user_id'])
        self.mgr = GHRepoManager(request.db, user_id)
        
    def collection_query(self):
        return self.mgr.query()

    def get(self):
        id = self.request.matchdict['id']
        if id == 'main':
            id = self.user_id
        o = self.mgr.get(id)
        return o.serialize()
    
