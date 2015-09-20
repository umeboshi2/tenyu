
import os
from ConfigParser import ConfigParser
from datetime import datetime

from cornice.resource import resource, view
from trumpet.views.base import BaseUserView
from trumpet.views.rest import BaseManagementResource

from tenyu.models.sitecontent import SiteText
from tenyu.views.rest import MAIN_RESOURCE_ROOT
from tenyu.views.util import make_resource
from tenyu.managers.wiki import WikiManager


rscroot = MAIN_RESOURCE_ROOT
sitetext_path = os.path.join(rscroot, 'sitetext')


def convert_range_to_datetime(start, end):
    "start and end are timestamps"
    start = datetime.fromtimestamp(float(start))
    end = datetime.fromtimestamp(float(end))
    return start, end

@resource(permission='admin', **make_resource(sitetext_path, ident='name'))
class SiteTextResource(BaseManagementResource):
    mgrclass = WikiManager
    def collection_post(self):
        request = self.request
        db = request.db
        name = request.json['name']
        content = request.json['content']
        #type = request.json.get('type', 'tutwiki')
        page = self.mgr.add_page(name, content)
        response = dict(data=page.serialize(), result='success')
        return response

    def put(self):
        request = self.request
        db = request.db
        name = self.request.matchdict['name']
        page = self.mgr.getbyname(name)
        if page is not None:
            content = request.json.get('content')
            page = self.mgr.update_page(page.id, content)
            page = page.serialize()
            response = dict(result='success')
        else:
            response = dict(result='failure')
        response['data'] = page
        return response

    def delete(self):
        raise RuntimeError, "Implement me!!"
        request = self.request
        db = request.db
        id = int(request.matchdict['id'])
        with transaction.manager:
            st = db.query(SiteText).get(id)
            if st is not None:
                db.delete(st)
        return dict(result='success')
    
    def get(self):
        name = self.request.matchdict['name']
        return self.serialize_object(self.mgr.getbyname(name))

    
