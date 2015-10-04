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

# input for file upload
# HTML <input> accept Attribute
#<input type="file" name="fileToUpload" accept="image/*">

from tenyu.managers.webobjects import WebObjectManager
from tenyu.managers.webobjects import AppModelManager

from tenyu.views.rest import APIROOT


rscroot = os.path.join(APIROOT, 'main', 'webobjects')

admin_path = os.path.join(rscroot, 'admin')
main_path = os.path.join(rscroot, 'main')

appmodel_path = os.path.join(rscroot, 'appmodels')

@resource(collection_path=main_path,
          path=os.path.join(main_path, '{id}'))
class MainWebObjectsView(BaseResource):
    def __init__(self, request):
        super(MainWebObjectsView, self).__init__(request)
        settings = request.registry.settings
        self.mgr = WebObjectManager(request.db)

    def serialize_object(self, dbobj):
        data = dbobj.serialize()
        data['content'] = dbobj.content
        #import pdb ; pdb.set_trace()
        #data['thumbnail'] = base64.b64encode(dbobj.thumbnail)
        return data

    def collection_query(self):
        return self.mgr.query()

    def get(self):
        id = int(self.request.matchdict['id'])
        dbobj = self.mgr.get(id)
        if 'content' in self.request.GET:
            return dbobj.content
        return self.serialize_object(dbobj)

    def _get_json_from_request(self):
        data = self.request.json
        name = data['name']
        type = data['type']
        content = data['content']
        return name, type, content
    
    def put(self):
        id = int(self.request.matchdict['id'])
        name, type, content = self._get_json_from_request()
        dbobj = self.mgr.update_object(id, name, type, content)
        return self.serialize_object(dbobj)
    
        
    def collection_post(self):
        name, type, content = self._get_json_from_request()
        wobject = self.mgr.add_object(name, type, content)
        return dict(object=wobject.serialize(), result='success')

    def _handleerrors(self):
        try:
            pass
        except FilenameInDatabaseError:
            raise HTTPConflict("This file already exists.")
        except ImageFileExistsError:
            raise HTTPConflict("This file already exists.")
        

@resource(collection_path=appmodel_path,
          path=os.path.join(appmodel_path, '{name}'))
class MainAppModelsView(BaseResource):
    def __init__(self, request):
        super(MainAppModelsView, self).__init__(request)
        settings = request.registry.settings
        self.mgr = AppModelManager(request.db)

    def serialize_object(self, dbobj):
        data = dbobj.serialize()
        data['content'] = dbobj.content
        return data

    def collection_query(self):
        return self.mgr.query()

    def get(self):
        name = int(self.request.matchdict['name'])
        dbobj = self.mgr.get_by_name(name)
        return self.serialize_object(dbobj)

    def _get_json_from_request(self):
        data = self.request.json
        name = data['name']
        content = data['content']
        return name, content
    
    def put(self):
        name = int(self.request.matchdict['name'])
        name, content = self._get_json_from_request()
        dbobj = self.mgr.update_object(id, name, content)
        return self.serialize_object(dbobj)
    
        
    def collection_post(self):
        name, content = self._get_json_from_request()
        wobject = self.mgr.add_object(name, type, content)
        return dict(object=wobject.serialize(), result='success')

