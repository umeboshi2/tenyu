from pyramid.config import Configurator
from sqlalchemy import engine_from_config
from sqlalchemy.orm import sessionmaker

from chert.alchemy import Base

from trumpet.security import authn_policy, authz_policy
from trumpet.config import add_static_views

from trumpet.models.base import DBSession, make_scoped_session

from trumpet.models.usergroup import User
from trumpet.models.celery import CeleryTask

import tenyu.models.sitecontent
import tenyu.models.webobjects
import tenyu.models.celerytasks
import chert.gitannex.annexdb.schema
from chert.github import make_client


from tenyu.models.truffula import Base as TRFBase

# FIXME -- APIROOT needs to be in config
APIROOT = '/rest/v0'



def make_truffula_session(settings):
    dburl = settings['truffuladb.url']
    dbsettings = {'sqlalchemy.url' : dburl}
    engine = engine_from_config(dbsettings)
    session_class = make_scoped_session()
    session_class.configure(bind=engine)
    TRFBase.metadata.bind = engine
    return session_class

def make_github_client(settings):
    user = settings['default.github.user']
    password = settings['default.github.password']
    client = make_client(user, password)
    return client

def clean_settings_for_serialization(settings):
        # FIXME, need better way to clean up
        # settings for serialization
        settings = settings.copy()
        badkeys = list()
        for key in settings:
            if key.startswith('debug') or key.endswith('sessionmaker'):
                badkeys.append(key)
        if 'db.usermodel' in settings:
            badkeys.append('db.usermodel')
        for key in badkeys:
            del settings[key]
        return settings

def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    trfsession = make_truffula_session(settings)
    settings['trfdb.sessionmaker'] = trfsession

    settings['github_client'] = make_github_client(settings)
    
    engine = engine_from_config(settings, 'sqlalchemy.')
    settings['db.sessionmaker'] = DBSession
    settings['db.usermodel'] = User
    settings['db.usernamefield'] = 'username'


    
    DBSession.configure(bind=engine)
    Base.metadata.bind = engine
    Base.metadata.create_all(engine)
    root_factory = 'trumpet.resources.RootGroupFactory'
    request_factory = 'tenyu.request.TenyuRequest'
    config = Configurator(settings=settings,
                          root_factory=root_factory,
                          request_factory=request_factory,
                          authentication_policy=authn_policy,
                          authorization_policy=authz_policy)
    config.include('cornice')
    config.include('pyramid_beaker')
    #config.include('pyramid_celery')
    config.configure_celery(global_config['__file__'])
    
    #config.add_static_view('static', 'static', cache_max_age=3600)
    client_view = 'tenyu.views.client.ClientView'
    config.add_route('home', '/')
    config.add_route('apps', '/app/{appname}')
    config.add_view(client_view, route_name='home')
    config.add_view(client_view, route_name='apps')
    config.add_view(client_view, name='login')
    config.add_view(client_view, name='logout')
    # FIXME - get client view to understand it hit forbidden
    config.add_view('tenyu.views.client.forbidden_view',
                    context='pyramid.httpexceptions.HTTPForbidden')
    config.add_view(client_view, name='admin', permission='admin')
    # static assets
    serve_static_assets = False
    if 'serve_static_assets' in settings and settings['serve_static_assets'].lower() == 'true':
        serve_static_assets = True

    if serve_static_assets:
        add_static_views(config, settings)
        
    config.add_route('repos_calendar', '/rest/v0/main/ghub/repocalendar')
    config.add_view('tenyu.views.rest.ghub.RepoCalendarView',
                    route_name='repos_calendar',
                    renderer='json',)
        
    config.scan('tenyu.views.rest.currentuser')
    config.scan('tenyu.views.rest.useradmin')
    config.scan('tenyu.views.rest.sitetext')
    config.scan('tenyu.views.rest.vtstuff')
    config.scan('tenyu.views.rest.wikipages')
    config.scan('tenyu.views.rest.ghub')
    config.scan('tenyu.views.rest.gitannex')
    config.scan('tenyu.views.rest.siteimages')
    config.scan('tenyu.views.rest.webobjects')
    config.scan('tenyu.views.rest.dbadmin')
    config.scan('tenyu.views.rest.celerytasks')

    siteimages_resource = settings['default.siteimages.resource']
    siteimages_path = settings['default.siteimages.directory']
    config.add_static_view('siteimages', path=siteimages_path)
    
    if 'default.vtimages.directory' in settings:
        vrsrc = settings['default.vtimages.resource']
        vpath = settings['default.vtimages.directory']
        config.add_static_view(vrsrc, path=vpath)

    return config.make_wsgi_app()
