#!/usr/bin/env python
import os, sys
import cPickle as Pickle
import json
from datetime import datetime

from sqlalchemy import engine_from_config
from sqlalchemy import and_, or_
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm.exc import NoResultFound

from chert import gitannex
from chert.alchemy import make_sqlite_session
from chert.alchemy import make_postgresql_session

from chert.gitannex.annexdb.schema import Base
from chert.gitannex.annexdb.schema import AnnexKey, AnnexFile
from chert.gitannex.annexdb.schema import ArchiveFile
from chert.gitannex.annexdb.schema import AnnexRepository, RepoFile

import chert.gitannex.annexdb.dbfunc as DBF
import chert.gitannex.annexdb.archives as ARK

from pyramid_celery import celery_app as app

#from trumpet.models.base import DBSession
from tenyu.managers.gitannex import AnnexFileManager

POPULATE_ANNEXDB = 'POPULATE_ANNEXDB'

@app.task
def hello_world():
    return "Hello World!"



@app.task(bind=True)
def populate_annex_files(self, dburl, annex_directory):
    #if not self.request.called_directly:
    #    self.update_state(state='STARTED')
    #self.request.id = POPULATE_ANNEXDB
    #import time
    #time.sleep(5)
    sessionmaker = make_postgresql_session(dburl)
    session = sessionmaker()
    #session.commit()
    mgr = AnnexFileManager(session, annex_directory)
    mgr.populate_files()
    session.commit()
    
    

@app.task
def populate_whereis(session):
    DBF.populate_whereis(session)
    
