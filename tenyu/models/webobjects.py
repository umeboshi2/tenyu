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

class WebObject(TimeStampMixin, Base):
    __tablename__ = 'web_objects'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(200), unique=True)
    type = Column(Unicode(200))
    content = Column(JSONB)
    
    
class AppModel(TimeStampMixin, Base):
    __tablename__ = 'app_models'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(200), unique=True)
    content = Column(JSONB)
    
class UserConfig(TimeStampMixin, Base):
    __tablename__ = 'userconfig_json'
    user_id = Column(Integer, ForeignKey('users.id'), primary_key=True)
    content = Column(JSONB)

