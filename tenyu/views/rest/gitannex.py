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


from tenyu.views.rest import APIROOT


from pyramid_celery import celery_app
from tenyu.tasks.annexdb import populate_annex_files

rscroot = os.path.join(APIROOT, 'main', 'gitannex')

admin_path = os.path.join(rscroot, 'dbadmin')
repos_path = os.path.join(rscroot, 'repos')
keys_path = os.path.join(rscroot, 'keys')
files_path = os.path.join(rscroot, 'paths')

POPULATE_ANNEXDB = 'POPULATE_ANNEXDB'

@resource(path=admin_path)
class AnnexAdminView(BaseResource):
    def __init__(self, request):
        super(AnnexAdminView, self).__init__(request)
        settings = request.registry.settings
        annex_directory = settings['default.gitannex.annex_path']
        self.repomgr = AnnexRepoManager(request.db, annex_directory)
        self.filemgr = AnnexFileManager(request.db, annex_directory)
        self.annex_directory = annex_directory
        self.dburl = settings['sqlalchemy.url']
        self.session = request.db



    def _setup_repos(self):
        dbmodel = self.repomgr.dbmodel
        if not self.session.query(dbmodel).count():
            self.repomgr.setup_repositories()

    def setup_repos(self):
        self._setup_repos()
        return self.get_info()
        
    def populate_annexdb(self):
        new_job = False
        ip = celery_app.control.inspect()
        result = ip.app.AsyncResult(POPULATE_ANNEXDB)
        if result.status == 'PENDING':
            self._setup_repos()
            args = (self.dburl, self.annex_directory)
            result = populate_annex_files.apply_async(
                args, task_id=POPULATE_ANNEXDB,
                countdown=0)
            new_job = True
        return self.get_info(inspector=ip, new_job=new_job)
    
    

    def post(self):
        data = self.request.json
        action = data['action']
        if action == 'populate_database':
            return self.populate_annexdb()
        elif action == 'setup_repos':
            return self.setup_repos()
        return self.get_info()
    
    
    def delete(self):
        self.filemgr.delete_everything_tm()
        ip = celery_app.control.inspect()
        result = ip.app.AsyncResult(POPULATE_ANNEXDB)
        if result.status == 'SUCCESS':
            result.forget()
        return self.get_info(inspector=ip)

    def get_info(self, inspector=None, new_job=False):
        if inspector is None:
            inspector = celery_app.control.inspect()
        result = inspector.app.AsyncResult(POPULATE_ANNEXDB)
        status = result.status
        populated = False
        if status in ['SUCCESS', 'STARTED']:
            populated = True
        repos = self.repomgr.query().count()
        keys = self.filemgr.keymgr.query().count()
        files = self.filemgr.query().count()
        data = dict(status=status, repos=repos, keys=keys, files=files,
                    populated=populated, new_job=new_job)
        return data
        

    def get(self, inspector=None):
        return self.get_info(inspector=inspector)
    
    
@resource(collection_path=repos_path,
          path=os.path.join(repos_path, '{uuid}'))
class AnnexReposView(BaseResource):
    def __init__(self, request):
        super(AnnexReposView, self).__init__(request)
        settings = request.registry.settings
        annex_directory = settings['default.gitannex.annex_path']
        self.mgr = AnnexRepoManager(request.db, annex_directory)
        #if not self.collection_query().count():
        #    self.mgr.setup_repositories()
        
    def collection_query(self):
        return self.mgr.query()

    def get(self):
        uuid = self.request.matchdict['uuid']
        if uuid == 'info':
            return self.mgr.get_info()
        o = self.mgr.get(id)
        return o.serialize()

