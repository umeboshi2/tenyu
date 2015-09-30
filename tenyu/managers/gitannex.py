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
from chert.gitannex.annexdb.schema import AnnexKey, AnnexFile



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

        
        

def _add_annexfile_attributes_common(dbobj, data):
    dbobj.name = data['file']
    for att in ['backend', 'bytesize', 'humansize',
                'keyname', 'hashdirlower', 'hashdirmixed',
                'unicode_decode_error']:
        setattr(dbobj, att, data[att])
        if data['mtime'] != 'unknown':
            raise RuntimeError, "Parse time?"
        

class AnnexKeyManager(GetByNameManager):
    dbmodel = AnnexKey
    def __init__(self, session, annex_directory):
        super(AnnexKeyManager, self).__init__(session)
        self.annex_directory = annex_directory
        self.pmgr = GitAnnexProcManager(self.annex_directory)

    def add_key(self, key):
        dbkey = AnnexKey()
        dbkey.name = key
        self.session.add(dbkey)
        return self.session.merge(dbkey)
    
        
class AnnexFileManager(GetByNameManager):
    dbmodel = AnnexFile
    def __init__(self, session, annex_directory):
        super(AnnexFileManager, self).__init__(session)
        self.keymgr = AnnexKeyManager(session, annex_directory)
        self.annex_directory = annex_directory
        self.pmgr = GitAnnexProcManager(self.annex_directory)

    def add_file(self, filedata, key_id):
        dbobj = AnnexFile()
        _add_annexfile_attributes_common(dbobj, filedata)
        dbobj.key_id = key_id
        self.session.add(dbobj)
        return self.session.merge(dbobj)

    def populate_files(self):
        proc = self.pmgr.make_find_proc()
        count = 0
        while proc.returncode is None:
            try:
                line = proc.stdout.next()
                count +=1
            except StopIteration:
                break
            data = gitannex.parse_json_line(
                line,
                convert_to_unicode=True,
                verbose_warning=True)
            key = data['key']
            dbkey = self.keymgr.get_by_name(key)
            if dbkey is None:
                dbkey = self.keymgr.add_key(key)
            self.add_file(data, dbkey.id)
        if proc.returncode:
            msg = "find proc returned %d" % proc.returncode
            raise RuntimeError, msg

        
    def populate_files_tm(self):
        with transaction.manager:
            self.populate_files()

    def delete_everything(self):
        self.session.query(AnnexFile).delete()
        self.session.query(AnnexKey).delete()
        self.session.query(AnnexRepository).delete()
        
    def delete_everything_tm(self):
        with transaction.manager:
            self.delete_everything()
            
