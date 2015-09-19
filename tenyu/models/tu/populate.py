import transaction

from sqlalchemy.exc import IntegrityError

from base import Group, UserGroup
from base import Contact, Audience, Venue
from base import EventType, Event, User
from base import Password
from base import DBSession, Base

from content import HostImage


def _populate_():
    transaction.begin()
    session = DBSession()

    session.flush()
    transaction.commit()
        
def populate_locations():
    session = DBSession()
    # locations come first
    # admin must suppy locations
    # since a user has a default audience(location)
    # The default location for bootstrapping
    # is home base of application
    locations = ['Hattiesburg', 'Petal', 'Oak Grove', 'New Orleans', 'Laurel',
                 'Sumrall']
    with transaction.manager:
        for location in locations:
            a = Audience(location)
            session.add(a)
        
def populate_groups():
    session = DBSession()
    # I may remove guest group
    groups = ['user', 'host', 'admin', 'guest']
    with transaction.manager:
        for groupname in groups:
            group = Group(groupname)
            session.add(group)
        
def populate_contacts():
    session = DBSession()
    contacts = [
        ('Joseph', 'Rawson', 'joseph.rawson.works@gmail.com', '(601)-297-2819'),
        ('Greg', 'Prine', 'greg.prine@gmail.com'),
        ('Clark', 'Kent', 'superman@jla.org'),
        ('Bruce', 'Wayne', 'batman@jla.org'),
        ('Hattie', 'Hardy', 'clerk@hubcity.com')
        ]
    with transaction.manager:
        for contact_args in contacts:
            contact = Contact(*contact_args)
            session.add(contact)

def populate_users():
    session = DBSession()
    users = [
        ('umeboshi', 1, 'admin'),
        ('gpprine', 2, 'admin'),
        ('superman', 3, 'host'),
        ('batman', 4, 'host'),
        ('hubclerk', 5, 'host')
        ]
    with transaction.manager:
        for uname, id, role in users:
            user = User(uname, id)
            user.role = role
            user.default_audience_id = 1
            session.add(user)

def populate_usergroups():
    session = DBSession()
    # I may remove guest group
    #groups = ['user', 'host', 'admin', 'guest']
    users = [(1,u) for u in range(1,6)]
    hosts = [(2,3), (2,4), (2,5), (2,1)]
    admins = [(3,1), (3,2)]
    all_giduid = users + hosts + admins
    with transaction.manager:
        for gid, uid in all_giduid:
            row = UserGroup(gid, uid)
            session.add(row)
        
def populate_eventtypes():
    session = DBSession()
    event_types = ['Musical Performance', 'Monthly Special',
                   'Weekly Special', 'Live Performance',
                   "Trader's Market", 'Social Gathering', 'Seminar']
    with transaction.manager:
        for etype in event_types:
            event_type = EventType(etype)
            session.add(event_type)
        
def populate_batman_venues():
    session = DBSession()
    venues = ['Wayne Manor', 'Bat Cave', 'City Hall']
    with transaction.manager:
        u = session.query(User).filter_by(username='batman').one()
    with transaction.manager:
        for v in venues:
            vv = Venue(u.id, v, 1)
            session.add(vv)
        
def populate_venues():
    session = DBSession()
    venues = ['Jackie Dole', 'Thirsty Hippo', 'Town Square Park']
    with transaction.manager:
        for venue in venues:
            v = Venue(1, venue, 1)
            session.add(v)
        
def populate_passwords():
    session = DBSession()
    password = '$6$noderest$r9eTyBGzlAh34frrKa0aspVQIv0W4mZsXkZm8khwOSlhp0ouYxjtxn2zst88G77f0Po7.BnS545CQPoApTw6T.'
    with transaction.manager:
        for user_id in range(1,6):
            pw = Password(user_id, password)
            session.add(pw)
        

def populate_images(imagedir='data/sitecontent/images'):
    session = DBSession()
    from trumpet.views.adminimages import ImageManager
    im = ImageManager(session)
    import os
    if not os.path.isdir(imagedir):
        imagedir = 'app-root/runtime/repo/wsgi/%s' % imagedir
        if not os.path.isdir(imagedir):
            pwd = os.getcwd()
            raise RuntimeError, "No imagedir, I am here: %s" % pwd
    for basename in os.listdir(imagedir):
        filename = os.path.join(imagedir, basename)
        imgfile = file(filename)
        im.add_image(basename, imgfile)
            


def populate():
    popfuns = [populate_locations, populate_groups, populate_contacts,
               populate_users, populate_usergroups, populate_eventtypes,
               populate_venues, populate_batman_venues,
               populate_passwords, populate_images]
    for pfun in popfuns:
        try:
            pfun()
        except IntegrityError:
            transaction.abort()
            
       
    


def initialize_sql(engine):
    DBSession.configure(bind=engine)
    Base.metadata.bind = engine
    Base.metadata.create_all(engine)
    try:
        populate()
    except IntegrityError:
        transaction.abort()


