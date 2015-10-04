import os
from ConfigParser import ConfigParser
from datetime import datetime
from urllib2 import HTTPError
import base64


from cornice.resource import resource, view
from pyramid.httpexceptions import HTTPNotFound
from pyramid.httpexceptions import HTTPFound
from pyramid.httpexceptions import HTTPForbidden
from pyramid.httpexceptions import HTTPConflict

from bs4 import BeautifulSoup

#from pyramid_celery import celery_app

#from trumpet.views.base import BaseUserViewCallable
from trumpet.views.rest.base import BaseResource
#from trumpet.views.util import get_start_end_from_request
from trumpet.resources import MemoryTmpStore
from trumpet.models.celery import CeleryTask

# input for file upload
# HTML <input> accept Attribute
#<input type="file" name="fileToUpload" accept="image/*">

from tenyu.managers.webobjects import WebObjectManager
from tenyu.managers.webobjects import AppModelManager
from tenyu.managers.taskmanager import TenyuTaskManager

from tenyu.views.rest import APIROOT


rscroot = os.path.join(APIROOT, 'main', 'celerytasks')

admin_path = os.path.join(rscroot, 'admin')
main_path = os.path.join(rscroot, 'main')

appmodel_path = os.path.join(rscroot, 'appmodels')

@resource(collection_path=main_path,
          path=os.path.join(main_path, '{task_id}'))
class CeleryTasksView(BaseResource):
    def __init__(self, request):
        super(CeleryTasksView, self).__init__(request)
        settings = request.registry.settings
        self.mgr = TenyuTaskManager(request.db)
        

    def collection_query(self):
        return self.mgr.query()

    def get(self):
        task_id = self.request.matchdict['task_id']
        tenyutask, celerytask = self.mgr.get_by_task_id(task_id)
        #return self.serialize_object(dbobj)
        tt  = tenyutask.serialize()
        ct = celerytask.serialize()
        return dict(tenyu=tt, celery=ct)
    
