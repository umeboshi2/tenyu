import transaction

from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import Unicode, UnicodeText
from sqlalchemy import ForeignKey
from sqlalchemy import Date, Time, DateTime
from sqlalchemy import Enum

from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.declarative import declarative_base

from sqlalchemy.orm import scoped_session
from sqlalchemy.orm import sessionmaker
from sqlalchemy.orm import relationship, backref

from zope.sqlalchemy import ZopeTransactionExtension

DBSession = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))
Base = declarative_base()

########################### RULES ##############################
# A User has a single Contact (one contact:many users).
#
#   An Event depends on an EventType.  An EventType must be
# created before an Event is created.
#
# A "host" must have a Venue to promote an Event.
#
# Multiple "hosts" can promote Event(s) at the same Venue
#
# An Event can have multiple Venues (such as a festival)
#
# When a "host" claims a Venue, this host selects the other
# hosts that can promote Event(s) at this Venue.
#
################################################################




RoleType = Enum('admin', 'host', 'user', 'guest', name='roletype')


class Contact(Base):
    __tablename__ = 'contacts'
    id = Column(Integer, primary_key=True)
    firstname = Column(Unicode(50))
    lastname = Column(Unicode(50))
    email = Column(Unicode(50), unique=True)
    phone = Column(Unicode(20))
    users = relationship('User')
    
    def __init__(self, firstname='', lastname='', email='', phone=''):
        if firstname:
            self.firstname = firstname
        if lastname:
            self.lastname = lastname
        if email:
            self.email = email
        if phone:
            self.phone = phone
            

class Audience(Base):
    __tablename__ = 'audiences'
    id = Column(Integer, primary_key=True)
    location = Column(Unicode(50), unique=True)

    def __init__(self, location=None):
        self.location = location
        
class Venue(Base):
    __tablename__ = 'venues'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(50), unique=True)
    audience_id = Column(Integer, ForeignKey('audiences.id'))

    def __init__(self, name=None, audience_id=None):
        self.name = name
        self.audience_id = audience_id
    
class EventType(Base):
    __tablename__ = 'event_types'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(50), unique=True)

    def __init__(self, name=None):
        self.name = name
    

class Event(Base):
    __tablename__ = 'events'
    id = Column(Integer, primary_key=True)
    start_date = Column(Date)
    start_time = Column(Time)
    end_date = Column(Date)
    end_time = Column(Time)
    name = Column(Unicode(100), unique=True)
    title = Column(Unicode(255))
    description = Column(UnicodeText)
    originator = Column(Integer, ForeignKey('users.id'))
    

    def __init__(self, name=None):
        self.name = name
        
class EventVenue(Base):
    __tablename__ = 'event_venues'
    event_id = Column(Integer,
                      ForeignKey('events.id'), primary_key=True)
    venue_id = Column(Integer,
                      ForeignKey('venues.id'), primary_key=True)

    def __init__(self, event_id, venue_id):
        self.event_id = event_id
        self.venue_id = venue_id
        
# this are the venues that a host plans
# events for
class HostedVenue(Base):
    __tablename__ = 'hosted_venues'
    user_id = Column(Integer,
                     ForeignKey('users.id'), primary_key=True)
    venue_id = Column(Integer,
                      ForeignKey('venues.id'), primary_key=True)

    def __init__(self, user_id, venue_id):
        self.user_id = user_id
        self.venue_id = venue_id

"""    
class HostedEvent(Base):
    __tablename__ = 'hosted_events'
    event_venue_id = Column(Integer,
                            ForeignKey('event_venues.id'), primary_key=True)
    user_id = Column(Integer,
                     ForeignKey('users.id'), primary_key=True)

    def __init__(self, event_venue_id, user_id):
        self.event_venue_id = event_id
        self.user_id = user_id
        
"""

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    username = Column(Unicode(50), unique=True)
    contact_id = Column(Integer, ForeignKey('contacts.id'))
    role = Column(RoleType)
    default_audience_id = Column(Integer, ForeignKey('audiences.id'))
    pw = relationship('Password', uselist=False)

    def __init__(self, username=None, contact_id=None):
        self.username = username
        self.contact_id = contact_id
        self.role = 'guest'

    def __repr__(self):
        return self.username

    def get_groups(self):
        return [g.name for g in self.groups]
    

class Password(Base):
    __tablename__ = 'passwords'
    user_id = Column(Integer, ForeignKey('users.id'), primary_key=True)
    password = Column(Unicode(150))
    
    def __init__(self, user_id, password):
        self.user_id = user_id
        self.password = password


class Group(Base):
    __tablename__ = 'groups'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(50))

    def __init__(self, name):
        self.name = name

class UserGroup(Base):
    __tablename__ = 'group_user'
    group_id = Column(Integer, ForeignKey('groups.id'), primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), primary_key=True)

    def __init__(self, gid, uid):
        self.group_id = gid
        self.user_id = uid
        

    
#User.main_audience = relationship(Audience, backref='audiences')
User.contact = relationship(Contact)

User.groups = relationship(Group, secondary='group_user')

HostedVenue.venue = relationship(Venue)
