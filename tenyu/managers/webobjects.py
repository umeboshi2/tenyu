import os
from ConfigParser import ConfigParser
from StringIO import StringIO
from sqlalchemy.orm.exc import NoResultFound
import transaction


from trumpet.security import encrypt_password
from trumpet.managers.base import BaseManager

from tenyu.models.webobjects import WebObject

class WebObjectManager(BaseManager):
    dbmodel = WebObject
    def __init__(self, session):
        super(WebObjectManager, self).__init__(session)

    def add_object(self, content, name=None):
        with transaction.manager:
            wo = WebObject()
            wo.content = content
            if name is not None:
                wo.name = name
            self.session.add(wo)
        return self.session.merge(wo)
    
    def delete_everything(self):
        self.query().delete()
        
    def delete_everything_tm(self):
        with transaction.manager:
            self.delete_everything()
            
