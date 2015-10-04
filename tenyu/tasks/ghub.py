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
from chert.alchemy import Base


from pyramid_celery import celery_app as app

#from trumpet.models.base import DBSession
from tenyu.managers.gitannex import AnnexFileManager

from tenyu.managers.ghub import GHRepoManager

#class BaseRepoView(BaseResource):
#    def __init__(self, request):
#        super(BaseRepoView, self).__init__(request)
#        settings = request.registry.settings


@app.task(bind=True)
def clone_github_repo(self, settings, dbrepo_id):
    dburl = settings['sqlalchemy.url']
    sessionmaker = make_postgresql_session(dburl)
    session = sessionmaker()
    user_id = int(settings['default.github.user_id'])
    mgr = GHRepoManager(session, user_id)
    mgr.set_repo_path(settings['default.github.repo_path'])
    dbrepo = mgr.get(dbrepo_id)
    repo = mgr.clone_repo(dbrepo)
    return repo

    
