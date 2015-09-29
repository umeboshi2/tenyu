import time
from datetime import datetime

from pyramid_celery import celery_app as app

from tenyu.managers.gitannex import AnnexRepoManager

mgr = AnnexRepoManager('ignore', '/freespace/annex')

import tenyu.tasks.annexdb



from celery import current_app
# `after_task_publish` is available in celery 3.1+
# for older versions use the deprecated `task_sent` signal
from celery.signals import after_task_publish

#@after_task_publish.connect
def update_sent_state(sender=None, body=None, **kwargs):
    # the task may not exist if sent using `send_task` which
    # sends tasks by name, so fall back to the default result backend
    # if that is the case.
    task = current_app.tasks.get(sender)
    backend = task.backend if task else current_app.backend
    backend.store_result(body['id'], None, "SENT")
    #import pdb ; pdb.set_trace()

@app.task
def adder(x, y):
    return x + y


@app.task
def gitannex_info():
    return mgr.get_info()

@app.task
def now():
    return datetime.now()

@app.task
def long_task():
    import time
    length = 30
    start = datetime.now()
    time.sleep(length)
    end = datetime.now()
    return dict(start=start, end=end)
