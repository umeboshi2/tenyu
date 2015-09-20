import transaction

from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import Unicode, UnicodeText
from sqlalchemy import ForeignKey, Boolean
from sqlalchemy import Date, Time, DateTime
from sqlalchemy import Enum
from sqlalchemy import PickleType

from sqlalchemy.exc import IntegrityError

from sqlalchemy.orm import relationship, backref

from trumpet.models.base import DBSession, Base
from trumpet.models.base import SerialBase

########################### RULES ##############################
# An Account has a single Contact (one contact:many users).
#
#   An Event depends on an EventType.  An EventType must be
# created before an Event is created.
#
# A "host" must have a Venue to promote an Event.
#
# //Multiple "hosts" can promote Event(s) at the same Venue
#
# //An Event can have multiple Venues (such as a festival)
#
# //When a "host" claims a Venue, this host selects the other
# //hosts that can promote Event(s) at this Venue.
#
# The three commented options above are too time consuming
# to implement at this point, while also needing some
# coordination and design considerations outside the scope
# of the website.
#
# I have just decided to layout the basic data model for
# festivals.  A festival is a collection of events that
# will span for a length of time (a day, a weekend, a week
# or two).  This will allow user to host a festival and
# invite other users to host events.
#
#
################################################################




RoleType = Enum('admin', 'host', 'user', 'guest', name='tu_roletype')

class Address(Base, SerialBase):
    __tablename__ = 'tu_addresses'
    id = Column(Integer, primary_key=True)
    street = Column(Unicode(150))
    street2 = Column(Unicode(150), default=None)
    city = Column(Unicode(50))
    state = Column(Unicode(2))
    zip = Column(Unicode(10))
    
class Contact(Base, SerialBase):
    __tablename__ = 'tu_contacts'
    id = Column(Integer, primary_key=True)
    firstname = Column(Unicode(50))
    lastname = Column(Unicode(50))
    email = Column(Unicode(50), unique=True)
    phone = Column(Unicode(20))
    accounts = relationship('Account')
    
    def __init__(self, firstname='', lastname='', email='', phone=''):
        if firstname:
            self.firstname = firstname
        if lastname:
            self.lastname = lastname
        if email:
            self.email = email
        if phone:
            self.phone = phone
            

class Audience(Base, SerialBase):
    __tablename__ = 'tu_audiences'
    id = Column(Integer, primary_key=True)
    location = Column(Unicode(50), unique=True)

    def __init__(self, location=None):
        self.location = location
        
class Venue(Base, SerialBase):
    __tablename__ = 'tu_venues'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(50), unique=True)
    audience_id = Column(Integer, ForeignKey('tu_audiences.id'))
    address_id = Column(Integer, ForeignKey('tu_addresses.id'))
    description = Column(UnicodeText)
    account_id = Column(Integer, ForeignKey('tu_accounts.id'))
    image_id = Column(Integer, ForeignKey('tu_site_images.id'))
    
    def __init__(self, account_id, name=None, audience_id=None):
        self.account_id = account_id
        self.name = name
        self.audience_id = audience_id
        self.address_id = None
        self.description = None
        self.image_id = None
    
class EventType(Base, SerialBase):
    __tablename__ = 'tu_event_types'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(50), unique=True)

    def __init__(self, name=None):
        self.name = name
    

class EventTypeColor(Base, SerialBase):
    __tablename__ = 'tu_event_type_colors'
    id = Column(Integer, ForeignKey('event_types.id'), primary_key=True)
    color = Column(Unicode(10))

    def __init__(self, color):
        self.color = color
        
    
class Event(Base, SerialBase):
    __tablename__ = 'tu_events'
    id = Column(Integer, primary_key=True)
    start_date = Column(Date)
    start_time = Column(Time)
    end_date = Column(Date)
    end_time = Column(Time)
    all_day = Column(Boolean, default=False)
    title = Column(Unicode(255))
    description = Column(UnicodeText)
    originator = Column(Integer, ForeignKey('tu_accounts.id'))
    event_type = Column(Integer, ForeignKey('tu_event_types.id'))
    venue_id = Column(Integer, ForeignKey('tu_venues.id'))

    def __init__(self, originator):
        self.originator = originator
    
        
class EventVenue(Base, SerialBase):
    __tablename__ = 'tu_event_venues'
    event_id = Column(Integer,
                      ForeignKey('tu_events.id'), primary_key=True)
    venue_id = Column(Integer,
                      ForeignKey('tu_venues.id'), primary_key=True)

    def __init__(self, event_id, venue_id):
        self.event_id = event_id
        self.venue_id = venue_id
        
class VenueInfo(Base, SerialBase):
    __tablename__ = 'tu_venue_info'
    id = Column(Integer,
                      ForeignKey('tu_venues.id'), primary_key=True)
    info = Column(PickleType)

    def __init__(self, id, info):
        self.id = id
        self.info = info
        
    
"""    
# this are the venues that a host plans
# events for
class HostedVenue(Base):
    __tablename__ = 'hosted_venues'
    account_id = Column(Integer,
                     ForeignKey('tu_accounts.id'), primary_key=True)
    venue_id = Column(Integer,
                      ForeignKey('tu_venues.id'), primary_key=True)

class HostedEvent(Base, SerialBase):
    __tablename__ = 'hosted_events'
    event_venue_id = Column(Integer,
                            ForeignKey('event_venues.id'), primary_key=True)
    user_id = Column(Integer,
                     ForeignKey('users.id'), primary_key=True)

    def __init__(self, event_venue_id, user_id):
        self.event_venue_id = event_id
        self.user_id = user_id
        
"""

class Festival(Base, SerialBase):
    __tablename__ = 'tu_festivals'
    id = Column(Integer, primary_key=True)



class FestivalEvent(Base, SerialBase):
    __tablename__ = 'tu_festival_events'
    festival_id = Column(Integer, ForeignKey('festivals.id'), primary_key=True)
    event_id = Column(Integer, ForeignKey('events.id'), primary_key=True)
    







class Account(Base, SerialBase):
    __tablename__ = 'tu_accounts'
    id = Column(Integer, primary_key=True)
    username = Column(Unicode(50), unique=True)
    contact_id = Column(Integer, ForeignKey('tu_contacts.id'))
    role = Column(RoleType)
    default_audience_id = Column(Integer, ForeignKey('tu_audiences.id'))
    pw = relationship('Password', uselist=False)

    def __init__(self, username=None, contact_id=None):
        self.username = username
        self.contact_id = contact_id
        self.role = 'guest'

    def __repr__(self):
        return self.username

    def get_groups(self):
        return [g.name for g in self.groups]
    

class Password(Base, SerialBase):
    __tablename__ = 'tu_passwords'
    account_id = Column(Integer, ForeignKey('tu_accounts.id'), primary_key=True)
    password = Column(Unicode(150))
    
    def __init__(self, account_id, password):
        self.account_id = account_id
        self.password = password


class Group(Base, SerialBase):
    __tablename__ = 'tu_groups'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(50), unique=True)

    def __init__(self, name):
        self.name = name

class AccountGroup(Base, SerialBase):
    __tablename__ = 'tu_group_account'
    group_id = Column(Integer, ForeignKey('tu_groups.id'), primary_key=True)
    account_id = Column(Integer, ForeignKey('tu_accounts.id'), primary_key=True)

    def __init__(self, gid, uid):
        self.group_id = gid
        self.account_id = account_id
        

    
#User.main_audience = relationship(Audience, backref='audiences')
Account.contact = relationship(Contact)

Account.groups = relationship(Group, secondary='tu_group_user')

Group.accounts = relationship(Account, secondary='tu_group_user')


Venue.events = relationship(Event, secondary='event_venues')

Event.venue = relationship(Venue, backref='venue_id')

# list tables to drop them when testing
models = [Contact, Audience, Venue, EventType, Event,
          EventVenue, Account, Password, Group, UserGroup]
