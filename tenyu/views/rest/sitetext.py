
import os
from ConfigParser import ConfigParser
from datetime import datetime

from cornice.resource import resource, view
from trumpet.views.base import BaseUserView
from trumpet.views.rest import BaseManagementResource

from tenyu.models.sitecontent import SiteText
from tenyu.views.rest import MAIN_RESOURCE_ROOT
from tenyu.views.util import make_resource

#from tenyu.managers.wiki import WikiManager
from tenyu.managers.sitetext import SiteTextManager

rscroot = MAIN_RESOURCE_ROOT
sitetext_path = os.path.join(rscroot, 'sitetext')
sitetext_admin_path = os.path.join(rscroot, 'sitetextadmin')


def convert_range_to_datetime(start, end):
    "start and end are timestamps"
    start = datetime.fromtimestamp(float(start))
    end = datetime.fromtimestamp(float(end))
    return start, end

class BaseSiteTextResource(BaseManagementResource):
    mgrclass = SiteTextManager
    def get(self):
        id = int(self.request.matchdict['id'])
        return self.serialize_object(self.mgr.get(id))
    



@resource(permission='admin', **make_resource(sitetext_admin_path, ident='id'))
class SiteTextAdminResource(BaseSiteTextResource):
    mgrclass = SiteTextManager
    def collection_post(self):
        request = self.request
        db = request.db
        name = request.json['name']
        content = request.json['content']
        type = request.json.get('type', 'text')
        page = self.mgr.add_text(name, type, content)
        response = dict(data=page.serialize(), result='success')
        return response

    def put(self):
        request = self.request
        db = request.db
        id = int(self.request.matchdict['id'])
        page = self.mgr.get(id)
        if page is not None:
            page.content = request.json.get('content')
            page = self.mgr.update_text(page.serialize())
            page = page.serialize()
            response = dict(result='success')
        else:
            response = dict(result='failure')
        response['data'] = page
        #import pdb ; pdb.set_trace()
        return response

    def delete(self):
        id = int(request.matchdict['id'])
        self.mgr.delete_text(id)
        return dict(result='success')
    

@resource(**make_resource(sitetext_path, ident='id'))
class SiteTextResource(BaseSiteTextResource):
    pass

