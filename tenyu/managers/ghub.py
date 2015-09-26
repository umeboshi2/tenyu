from ConfigParser import ConfigParser
from StringIO import StringIO
from sqlalchemy.orm.exc import NoResultFound
import transaction


from trumpet.security import encrypt_password

from chert.github.githubdb import GitHubUser, GitHubRepo
from chert.github.repoman import RepoManager as BaseRepoManager

class BaseManager(object):
    def __init__(self, session):
        self.session = session

    def query(self):
        return self.session.query(self.dbmodel)

    def get(self, id):
        return self.query().get(id)

class GetByNameManager(BaseManager):
    def get_by_name_query(self, name):
        return self.query().filter_by(name=name)

    def get_by_name(self, name):
        q = self.get_by_name_query(name)
        try:
            return q.one()
        except NoResultFound:
            return None

    

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


class GHRepoManager(object):
    def __init__(self, session, user_id):
        self.session = session
        self.user_id = user_id
        
    def query(self):
        return self.session.query(GitHubRepo)

    def get(self, repo_id):
        return self.query().get(repo_id)


