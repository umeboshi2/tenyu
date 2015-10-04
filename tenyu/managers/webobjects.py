import os
from ConfigParser import ConfigParser
from StringIO import StringIO
from datetime import datetime

from sqlalchemy.orm.exc import NoResultFound
import transaction


from trumpet.managers.base import BaseManager

from tenyu.models.webobjects import WebObject
from tenyu.models.webobjects import AppModel

class WebObjectManager(BaseManager):
    dbmodel = WebObject
    def __init__(self, session):
        super(WebObjectManager, self).__init__(session)

    def add_object(self, name, type, content):
        with transaction.manager:
            wo = WebObject()
            wo.name = name
            wo.type = type
            wo.content = content
            self.session.add(wo)
        return self.session.merge(wo)

    def update_object(self, id, name, type, content):
        with transaction.manager:
            wo = self.get(id)
            wo.name = name
            wo.type = type
            wo.content = content
            wo.updated_at = datetime.now()
            self.session.add(wo)
        return self.session.merge(wo)
            
    def delete_everything(self):
        self.query().delete()
        
    def delete_everything_tm(self):
        with transaction.manager:
            self.delete_everything()
            
class AppModelManager(BaseManager):
    dbmodel = AppModel
    def __init__(self, session):
        super(AppModelManager, self).__init__(session)

    def add_object(self, name, type, content):
        with transaction.manager:
            wo = AppModel()
            wo.name = name
            wo.content = content
            self.session.add(wo)
        return self.session.merge(wo)

    def update_object(self, id, name, type, content):
        with transaction.manager:
            wo = self.get(id)
            wo.name = name
            wo.content = content
            wo.updated_at = datetime.now()
            self.session.add(wo)
        return self.session.merge(wo)
            
    def delete_everything(self):
        self.query().delete()
        
    def delete_everything_tm(self):
        with transaction.manager:
            self.delete_everything()
            
