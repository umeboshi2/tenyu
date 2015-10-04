import os
from ConfigParser import ConfigParser
from StringIO import StringIO
from datetime import datetime

from PIL import Image
from sqlalchemy.orm.exc import NoResultFound
import transaction

from chert.urlrepo import ImageRepo

from trumpet.managers.base import GetByNameManager

from tenyu.models.sitecontent import SiteText


class SiteTextManager(GetByNameManager):
    dbmodel = SiteText
    def __init__(self, session):
        self.session = session
        

    def add_text(self, name, type, content):
        with transaction.manager:
            t = SiteText()
            t.name = name
            t.type = type
            t.content = content
            self.session.add(t)
        return self.session.merge(t)

    def delete_text(self, id):
        with transaction.manager:
            i = self.session.query(SiteImage).get(id)
            i.delete()

    def update_text(self, data, id=None):
        if id is None:
            id = data['id']
        with transaction.manager:
            now = datetime.now()
            page = self.get(id)
            if page is None:
                raise HTTPNotFound, "No such page"
            updated = False
            for key in ['name', 'type', 'content']:
                if key in data:
                    setattr(page, key, data.get(key))
                    updated = True
            if updated:
                self.session.add(page)
        return self.session.merge(page)
    
            
