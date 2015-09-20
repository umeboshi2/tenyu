from datetime import datetime

import transaction

from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import Unicode, UnicodeText
from sqlalchemy import ForeignKey
from sqlalchemy import DateTime
from sqlalchemy import PickleType
from sqlalchemy import Enum


from sqlalchemy.orm import relationship, backref

from trumpet.models.base import DBSession, Base, SerialBase

from sqlalchemy.exc import IntegrityError

class SiteImage(Base, SerialBase):
    __tablename__ = 'site_images'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(200), unique=True)
    content = Column(PickleType)
    thumbnail = Column(PickleType)
    created = Column(DateTime)
    modified = Column(DateTime)
    
    def __init__(self, name=None, content=None):
        self.name = name
        self.content = content
        
    def __repr__(self):
        return self.name

    def serialize2(self):
        data = dict(id=self.id, name=self.name,
                    content=self.content, thumbnail=self.thumbnail)
        return data
    
    
        
VALID_TEXT_TYPES = ['html',
                    'rst', # restructured text
                    'md', # markdown
                    'tutwiki', # markdown text wiki tutorial
                    'text',] # just plain text

SiteTextType = Enum(*VALID_TEXT_TYPES, name='site_text_type')

class SiteText(Base, SerialBase):
    __tablename__ = 'site_text'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(200), unique=True)
    type = Column(Unicode(25))
    content = Column(UnicodeText)
    created = Column(DateTime)
    modified = Column(DateTime)
    
    def __init__(self, name=None, content=None, type='html'):
        self.name = name
        self.type = type
        self.content = content
        self.created = datetime.now()
        self.modified = datetime.now()

        
def populate_images(imagedir='images'):
    import os
    if not os.path.isdir(imagedir):
        print "No Images to populate"
        return
    session = DBSession()
    from trumpet.managers.admin.images import ImageManager
    im = ImageManager(session)
    for basename in os.listdir(imagedir):
        filename = os.path.join(imagedir, basename)
        imgfile = file(filename)
        im.add_image(basename, imgfile)
            

def populate_sitetext(directory):
    session = DBSession()
    import os
    if not os.path.isdir(directory):
        print "No Images to populate"
        return
    extension = '.md'
    pages = list()
    for basename in os.listdir(directory):
        if basename.endswith(extension):
            filename = os.path.join(directory, basename)
            if os.path.isfile(filename):
                content = file(filename).read()
                name = os.path.basename(filename[:-len(extension)])
                pages.append((name, content))
    try:
        with transaction.manager:
            for name, content in pages:
                page = SiteText(name, content)
                page.type = 'tutwiki'
                session.add(page)
    except IntegrityError:
        session.rollback()
