import os
from ConfigParser import ConfigParser
from datetime import datetime
from urllib2 import HTTPError

from cornice.resource import resource, view
from pyramid.httpexceptions import HTTPNotFound
from pyramid.httpexceptions import HTTPFound
from pyramid.httpexceptions import HTTPForbidden
from bs4 import BeautifulSoup

from trumpet.views.base import BaseUserViewCallable
from trumpet.views.rest.base import BaseResource
from trumpet.views.util import get_start_end_from_request

from tenyu.managers.ghub import GHRepoManager, GHUserManager

from tenyu.managers.gitannex import AnnexRepoManager


from tenyu.views.rest import APIROOT
        

rscroot = os.path.join(APIROOT, 'main', 'gitannex')
repos_path = os.path.join(rscroot, 'repos')
keys_path = os.path.join(rscroot, 'keys')
files_path = os.path.join(rscroot, 'paths')



@resource(collection_path=repos_path,
          path=os.path.join(repos_path, '{uuid}'))
class AnnexReposView(BaseResource):
    def __init__(self, request):
        super(AnnexReposView, self).__init__(request)
        settings = request.registry.settings
        annex_directory = settings['default.gitannex.annex_path']
        self.mgr = AnnexRepoManager(request.db, annex_directory)
        if not self.collection_query().count():
            self.mgr.setup_repositories()
        
    def collection_query(self):
        return self.mgr.query()

    def get(self):
        uuid = self.request.matchdict['uuid']
        if uuid == 'info':
            return self.mgr.get_info()
        o = self.mgr.get(id)
        return o.serialize()

