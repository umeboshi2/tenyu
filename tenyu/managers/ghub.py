from ConfigParser import ConfigParser
from StringIO import StringIO
from sqlalchemy.orm.exc import NoResultFound
import transaction


from trumpet.managers.base import BaseManager, GetByNameManager

from chert.github.githubdb import GitHubUser, GitHubRepo
from chert.github.repoman import RepoManager as BaseRepoManager


class GHUserManager(object):
    def __init__(self, session, user_id):
        self.session = session
        self.user_id = user_id
        
    def query(self):
        return self.session.query(GitHubUser)

    def get(self, user_id=None):
        if user_id is None:
            user_id = self.user_id
        return self.query().get(user_id)


class GHRepoManager(BaseRepoManager):
    def __init__(self, session, user_id):
        super(GHRepoManager, self).__init__(session, user_id)
        self.user_id = user_id
        
    def query(self):
        return self.session.query(GitHubRepo)

    def get(self, repo_id):
        return self.query().get(repo_id)

    def serialize(self, repo_id, dbobj=None):
        if dbobj is None:
            dbobj = self.get(repo_id)
        rdata = dbobj.serialize()
        rdata['local_repo_exists'] = self.local_repo_exists(dbobj)
        return rdata
        
    def myrepos_query(self, forks=False):
        return self.query().filter_by(owner_id=self.user_id,
                                      fork=forks)

    def others_query(self):
        q = self.query()
        return q.filter(GitHubRepo.owner_id != self.user_id)
    
    def _range_filter(self, query, column, start, end):
        query = query.filter(column >= start)
        query = query.filter(column <= end)
        return query

    # range is when repo updated on github
    def updated_range_filter(self, start, end, query=None):
        if query is None:
            query = self.query()
        return self._range_filter(query,
                                  GitHubRepo.updated_at_gh,
                                  start, end)
    
    def get_ranged_repos(self, start, end):
        #q = self.query()
        q = self.updated_range_filter(start, end)
        return q.all()
    
        
                             
