import transaction

from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import Unicode, UnicodeText
from sqlalchemy import ForeignKey
from sqlalchemy import Date, Time, DateTime
from sqlalchemy import Enum

from sqlalchemy.exc import IntegrityError

from sqlalchemy.orm import relationship, backref

from chert.alchemy SerialBase

from trumpet.models.base import DBSession, Base

from tenyu.models.sitecontent import SiteText, SiteImage


class HostImage(SerialBase, Base):
    __tablename__ = 'tu_host_images'
    account_id = Column(Integer, ForeignKey('tu_accounts.id'), primary_key=True)
    image_id = Column(Integer, ForeignKey('site_images.id'), primary_key=True)
    image = relationship(SiteImage)
    
    
    def __init__(self, user_id, image_id):
        self.user_id = user_id
        self.image_id = image_id
        
class VenueImage(SerialBase, Base):
    __tablename__ = 'tu_venue_images'
    venue_id = Column(Integer, ForeignKey('tu_venues.id'), primary_key=True)
    image_id = Column(Integer, ForeignKey('site_images.id'))

    def __init__(self, venue_id, image_id):
        self.venue_id = venue_id
        self.image_id = image_id

