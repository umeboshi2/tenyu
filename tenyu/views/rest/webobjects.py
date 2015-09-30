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


from tenyu.views.rest import APIROOT


rscroot = os.path.join(APIROOT, 'main', 'webobjects')

admin_path = os.path.join(rscroot, 'admin')
main_path = os.path.join(rscroot, 'main')


@resource(collection_path=main_path,
          path=os.path.join(main_path, '{id}'))
class MainWebObjectsView(BaseResource):
    def __init__(self, request):
        super(MainWebObjectsView, self).__init__(request)
        settings = request.registry.settings
        self.mgr = WebObjectManager(request.db)

    def serialize_object(self, dbobj):
        data = dbobj.serialize()
        #data['thumbnail'] = base64.b64encode(dbobj.thumbnail)
        return data

    def collection_query(self):
        return self.mgr.query()
    
    def collection_poster(self):
        data = self.request.POST
        name = data['imagefile']
        upload = data['imagefile']
        name = upload.filename
        fp = upload.file
        try:
            image = self.mgr.add_image(name, fp)
            return dict(image=image.serialize(), result='success')
        except FilenameInDatabaseError:
            raise HTTPConflict("This file already exists.")
        except ImageFileExistsError:
            raise HTTPConflict("This file already exists.")
        
