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

from trumpet.util import get_singleton_result
from trumpet.util import SingletonNotPresentError


from tenyu.managers.ghub import GHRepoManager, GHUserManager

from tenyu.managers.gitannex import AnnexRepoManager
from tenyu.managers.gitannex import AnnexFileManager

from tenyu.managers.dbadmin import MainDBAdminManager

from tenyu.views.rest import APIROOT


from pyramid_celery import celery_app
from tenyu.tasks.annexdb import populate_annex_files

rscroot = os.path.join(APIROOT, 'main', 'dbadmin')

main_path = os.path.join(rscroot, 'main')


@resource(path=main_path)
class MainDBAdminView(BaseResource):
    def __init__(self, request):
        super(MainDBAdminView, self).__init__(request)
        settings = request.registry.settings
        annex_directory = settings['default.gitannex.annex_path']
        self.annex_directory = annex_directory
        self.dburl = settings['sqlalchemy.url']
        self.session = request.db
        self.mgr = MainDBAdminManager(self.session, self.dburl,
                                      self.annex_directory)
        

    def post(self):
        data = self.request.json
        action = data['action']
        if action == 'populate_database':
            database = data['database']
            if database == 'gitannex':
                self.mgr.populate_annexdb()
        elif action == 'setup_repos':
            return self.setup_repos()
        return self.get()

    def delete(self):
        data = self.request.json
        db = data['database']
        if db == 'gitannex':
            data = self.mgr.delete_annex_db()
        return self.get()

    def get(self, inspector=None):
        data = dict()
        data['gitannex'] = self.mgr.get_annex_info(inspector=inspector)
        return data
          
    
