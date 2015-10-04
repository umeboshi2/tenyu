import os
from ConfigParser import ConfigParser
from StringIO import StringIO
from datetime import datetime

from sqlalchemy.orm.exc import NoResultFound
import transaction


from trumpet.managers.base import BaseManager
from trumpet.managers.base import GetByNameManager

from tenyu.models.celerytasks import TenyuTask
from trumpet.models.celery import CeleryTask

class TenyuTaskManager(GetByNameManager):
    dbmodel = TenyuTask

    def add_task(self, name, task_id, data=None):
        with transaction.manager:
            tt = TenyuTask()
            tt.task_id = task_id
            tt.name = name
            if data is not None:
                tt.data = data
            self.session.add(tt)
        return self.session.merge(tt)

    def get_by_task_id_query(self, task_id):
        query = self.session.query(TenyuTask, CeleryTask)
        query = query.filter(TenyuTask.task_id == CeleryTask.task_id)
        return query.filter(CeleryTask.task_id == task_id)

    def get_by_task_id(self, task_id):
        q = self.get_by_task_id_query(task_id)
        try:
            return q.one()
        except NoResultFound:
            return None

