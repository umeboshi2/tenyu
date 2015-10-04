import os
from ConfigParser import ConfigParser
from datetime import datetime
from urllib2 import HTTPError

from cornice.resource import resource, view
from pyramid.httpexceptions import HTTPNotFound
from pyramid.httpexceptions import HTTPFound
from pyramid.httpexceptions import HTTPForbidden
from bs4 import BeautifulSoup

from trumpet.views.base import BaseUserViewCallable
from trumpet.views.rest.base import BaseResource
from trumpet.views.util import get_start_end_from_request

from chert.github import make_client
from tenyu.managers.ghub import GHRepoManager, GHUserManager
from tenyu.managers.taskmanager import TenyuTaskManager
    


from pyramid_celery import celery_app
from tenyu.tasks.ghub import clone_github_repo

from tenyu.views.rest import APIROOT
from tenyu import clean_settings_for_serialization        

rscroot = os.path.join(APIROOT, 'main', 'ghub')
users_path = os.path.join(rscroot, 'users')
repos_path = os.path.join(rscroot, 'repos')

myrepos_path = os.path.join(rscroot, 'myrepos')
myforks_path = os.path.join(rscroot, 'forkedrepos')
otherrepos_path = os.path.join(rscroot, 'otherrepos')

@resource(collection_path=users_path,
          path=os.path.join(users_path, '{id}'))
class GHUserView(BaseResource):
    def __init__(self, request):
        super(GHUserView, self).__init__(request)
        settings = self.get_app_settings()
        user_id = int(settings['default.github.user_id'])
        self.mgr = GHUserManager(request.db, user_id)
        self.taskmgr = TenyuTaskManager(request.db)
        
    def collection_query(self):
        return self.mgr.query()

    def get(self):
        id = self.request.matchdict['id']
        if id == 'main':
            id = self.user_id
        o = self.mgr.get(id)
        return o.serialize()


class BaseRepoView(BaseResource):
    def __init__(self, request):
        super(BaseRepoView, self).__init__(request)
        settings = self.get_app_settings()
        user_id = int(settings['default.github.user_id'])
        self.mgr = GHRepoManager(request.db, user_id)
        self.mgr.set_repo_path(settings['default.github.repo_path'])
        self.mgr.set_github_client(settings['github_client'])
        self.taskmgr = TenyuTaskManager(request.db)
                                           
        
    def serialize_object(self, dbobj):
        return self.mgr.serialize('ignore', dbobj=dbobj)
    
    def get(self):
        id = self.request.matchdict['id']
        return self.mgr.serialize(id)

    def put(self):
        id = self.request.matchdict['id']
        raise NotImplementedError, "do something"



    
@resource(collection_path=repos_path,
          path=os.path.join(repos_path, '{id}'))
class GHRepoView(BaseRepoView):
    def collection_query(self):
        return self.mgr.query()

    def put(self):
        id = int(self.request.matchdict['id'])
        data = self.request.json
        action = data['action']
        if action == 'clone-repo':
            task = self.clone_github_repo(id)
        return task
    

    def clone_github_repo(self, id):
        settings = clean_settings_for_serialization(self.get_app_settings())
                
        ip = celery_app.control.inspect()
        result = clone_github_repo.apply_async((settings, id))
        task_name = 'github:clone:%d' % id
        self.taskmgr.add_task(task_name, result.task_id)
        data = self.get()
        data['task_id'] = result.task_id
        return data
    

############################################
############################################
############################################
############################################
############################################
#FIXME: these should be GET query options
# on GHRepoView, instead of having their
# own url directories.

@resource(collection_path=myrepos_path,
          path=os.path.join(myrepos_path, '{id}'))
class MyReposView(BaseRepoView):
    def collection_query(self):
        return self.mgr.myrepos_query()

@resource(collection_path=myforks_path,
          path=os.path.join(myforks_path, '{id}'))
class MyForksView(BaseRepoView):
    def collection_query(self):
        return self.mgr.myrepos_query(forks=True)


@resource(collection_path=otherrepos_path,
          path=os.path.join(otherrepos_path, '{id}'))
class OtherReposView(BaseRepoView):
    def collection_query(self):
        return self.mgr.others_query()
############################################
############################################
############################################
############################################
############################################

    
class RepoCalendarView(BaseUserViewCallable):
    def __init__(self, request):
        super(RepoCalendarView, self).__init__(request)
        settings = request.registry.settings
        user_id = int(settings['default.github.user_id'])
        self.mgr = GHRepoManager(request.db, user_id)
        self.get_ranged_repos()

    def get_ranged_repos(self, timestamps=False):
        start, end = get_start_end_from_request(self.request,
                                                timestamps=timestamps)
        #print start, end, "SDFSDFDFSDF"
        repos = self.mgr.get_ranged_repos(start, end)
        rlist = list()
        for rp in repos:
            rdata = rp.serialize()
            #import pdb ; pdb.set_trace()
            #del rdata['pickle']
            if 'allDay' not in rdata:
                rdata['allDay'] = False
            rdata['title'] = rp.full_name
            rdata['start'] = rdata['updated_at_gh']
            rdata['api_url'] = rdata['url']
            del rdata['url']
            rlist.append(rdata)
        self.response = rlist
    
        
