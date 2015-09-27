import time
from datetime import datetime

from pyramid_celery import celery_app as app

from tenyu.managers.gitannex import AnnexRepoManager

mgr = AnnexRepoManager('ignore', '/freespace/annex')

import tenyu.tasks.annexdb

@app.task
def adder(x, y):
    return x + y


@app.task
def gitannex_info():
    return mgr.get_info()

@app.task
def long_task():
    import time
    length = 30
    start = datetime.now()
    time.sleep(length)
    end = datetime.now()
    return dict(start=start, end=end)
