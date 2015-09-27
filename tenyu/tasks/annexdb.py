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


@app.task
def hello_world():
    return "Hello World!"

@app.task
def populate_database(session):
    DBF.populate_database(session)

@app.task
def populate_whereis(session):
    DBF.populate_whereis(session)
    
