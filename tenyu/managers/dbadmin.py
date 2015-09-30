import os
from ConfigParser import ConfigParser
from StringIO import StringIO
from sqlalchemy.orm.exc import NoResultFound
import transaction


from trumpet.security import encrypt_password
from trumpet.managers.base import BaseManager

from chert.gitannex.annexdb.schema import AnnexRepository
from chert.gitannex.annexdb.schema import AnnexKey, AnnexFile

from tenyu.managers.gitannex import AnnexRepoManager
from tenyu.managers.gitannex import AnnexKeyManager
from tenyu.managers.gitannex import AnnexFileManager

from pyramid_celery import celery_app
from tenyu.tasks.annexdb import populate_annex_files

POPULATE_ANNEXDB_TASK = 'POPULATE_ANNEXDB'

class MainDBAdminManager(BaseManager):
    def __init__(self, session, dburl, annex_directory):
        super(MainDBAdminManager, self).__init__(session)
        self.annex_directory = annex_directory
        self.dburl = dburl
        self.annex_repomgr = AnnexRepoManager(session, annex_directory)
        self.annex_filemgr = AnnexFileManager(session, annex_directory)


    def _setup_repos(self):
        dbmodel = self.annex_repomgr.dbmodel
        if not self.session.query(dbmodel).count():
            self.annex_repomgr.setup_repositories()
            
    def get_annex_info(self, inspector=None, new_job=False):
        if inspector is None:
            inspector = celery_app.control.inspect()
        result = inspector.app.AsyncResult(POPULATE_ANNEXDB_TASK)
        status = result.status
        populated = False
        if status in ['SUCCESS', 'STARTED']:
            populated = True
        repos = self.annex_repomgr.query().count()
        keys = self.annex_filemgr.keymgr.query().count()
        files = self.annex_filemgr.query().count()
        data = dict(status=status, repos=repos, keys=keys, files=files,
                    populated=populated, new_job=new_job)
        return data
        
    def delete_annex_db(self):
        self.annex_filemgr.delete_everything_tm()
        ip = celery_app.control.inspect()
        result = ip.app.AsyncResult(POPULATE_ANNEXDB_TASK)
        if result.status == 'SUCCESS':
            result.forget()
        return self.get_annex_info(inspector=ip)

    def populate_annexdb(self):
        new_job = False
        ip = celery_app.control.inspect()
        result = ip.app.AsyncResult(POPULATE_ANNEXDB_TASK)
        if result.status == 'PENDING':
            self._setup_repos()
            args = (self.dburl, self.annex_directory)
            result = populate_annex_files.apply_async(
                args, task_id=POPULATE_ANNEXDB_TASK,
                countdown=0)
            new_job = True
        return self.get_annex_info(inspector=ip, new_job=new_job)
        
        
    
