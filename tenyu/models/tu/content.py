import transaction

from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import Unicode, UnicodeText
from sqlalchemy import ForeignKey
from sqlalchemy import Date, Time, DateTime
from sqlalchemy import Enum

from sqlalchemy.exc import IntegrityError

from sqlalchemy.orm import relationship, backref

from trumpet.models.base import DBSession, Base
from trumpet.models.sitecontent import SiteText, SiteImage


class HostImage(Base):
    __tablename__ = 'host_images'
    user_id = Column(Integer, ForeignKey('users.id'), primary_key=True)
    image_id = Column(Integer, ForeignKey('site_images.id'), primary_key=True)
    image = relationship(SiteImage)
    
    
    def __init__(self, user_id, image_id):
        self.user_id = user_id
        self.image_id = image_id
        
class VenueImage(Base):
    __tablename__ = 'venue_images'
    venue_id = Column(Integer, ForeignKey('venues.id'), primary_key=True)
    image_id = Column(Integer, ForeignKey('site_images.id'))

    def __init__(self, venue_id, image_id):
        self.venue_id = venue_id
        self.image_id = image_id

