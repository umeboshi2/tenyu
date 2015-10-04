from datetime import datetime
import hashlib

import transaction

from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import Unicode, UnicodeText
from sqlalchemy import ForeignKey
from sqlalchemy import DateTime
from sqlalchemy import PickleType
from sqlalchemy import Enum

from sqlalchemy.dialects.postgresql import JSONB

from sqlalchemy.orm import relationship, backref

from chert.alchemy import SerialBase, Base
from chert.alchemy import TimeStampMixin

from trumpet.models.celery import CeleryTask

from sqlalchemy.exc import IntegrityError


class TenyuTask(TimeStampMixin, Base):
    __tablename__ = 'tenyu_tasks'
    id = Column(Integer, primary_key=True, nullable=False)
    task_id = Column(Unicode(255))
    name = Column(Unicode(200), unique=True)
    data = Column(PickleType)
    result = Column(Unicode(50))
    


    
