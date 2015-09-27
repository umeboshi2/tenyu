import os
from ConfigParser import ConfigParser
from StringIO import StringIO
from sqlalchemy.orm.exc import NoResultFound
import transaction


from trumpet.security import encrypt_password
from trumpet.managers.base import GetByNameManager

from chert import gitannex
from chert.gitannex.procmgr import GitAnnexProcManager

from chert.gitannex.annexdb.schema import AnnexRepository



class AnnexRepoManager(GetByNameManager):
    dbmodel = AnnexRepository
    def __init__(self, session, annex_directory):
        super(AnnexRepoManager, self).__init__(session)
        self.annex_directory = annex_directory
        self.pmgr = GitAnnexProcManager(self.annex_directory)
        
    def get_info(self):
        return self.pmgr.get_annex_info()
    
    def setup_repositories(self):
        info = self.get_info()
        with transaction.manager:
            for trust in ['untrusted', 'semitrusted', 'trusted']:
                rkey = '%s repositories' % trust
                for repo in info[rkey]:
                    ar = AnnexRepository()
                    name = repo['description'].strip()
                    if not name:
                        name = repo['uuid']
                    ar.name = name
                    ar.uuid = repo['uuid']
                    ar.trust = trust
                    self.session.add(ar)

        
        
        
