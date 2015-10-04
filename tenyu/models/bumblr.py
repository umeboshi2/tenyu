from datetime import datetime

from sqlalchemy import Sequence, Column, ForeignKey

# column types
from sqlalchemy import Integer, String, Unicode, UnicodeText
from sqlalchemy import BigInteger
from sqlalchemy import Boolean, Date, LargeBinary
from sqlalchemy import PickleType
from sqlalchemy import Enum
from sqlalchemy import DateTime

from sqlalchemy.orm import relationship, backref
from sqlalchemy.ext.declarative import declarative_base


from chert.alchemy import SerialBase
from chert.alchemy import compile_query

# orig is original size
# thumb is width 100
# smallsquare is width 75, height 75
# alt is all other sizes for photo
PhotoType = Enum('orig', 'alt', 'thumb', 'smallsquare',
                 name='tumblr_photo_type_enum')

Base = declarative_base()


####################################
## Data Types                     ##
####################################

_overthis = [
    'overten',
    'overtwenty',
    'overthirty',
    'overforty',
    'overfifty',
    'oversixty',
    'overseventy',
    'overeighty',
    'overninety',
    'overonehundred']



# properties
# source denotes blog with high source content
# followed denotes blog followed on client account
# follower denotes account following client account's blog
# liked_by_followed denotes blog followed by a 'followed'
# liked_by_follower denotes blog followed by a 'follower'
# favorite denotes a blog where posts are kept current
# ignored denotes a blog where posts are never gathered
# fulltrack denotes a blog where all posts are archived

DEFAULT_BLOG_PROPERTIES = ['source',
                           'followed',
                           'follower',
                           'liked_by_followed',
                           'liked_by_follower',
                           'favorite',
                           'ignored',
                           'fulltrack']
DEFAULT_BLOG_PROPERTIES += _overthis
OVERTHIS_MAP = dict([(10*i,n) for i,n in enumerate(_overthis, 1)])
del _overthis


####################################
## Tables                         ##
####################################
class RowCount(Base, SerialBase):
    __tablename__ = 'rowcounts'
    table = Column(String, primary_key=True)
    total = Column(BigInteger)
    
class BlogPropertyName(Base, SerialBase):
    __tablename__ = 'bumblr_blog_property_names'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode(200))


class Blog(Base, SerialBase):
    __tablename__ = 'bumblr_blogs'
    id = Column(Integer, primary_key=True)
    info = relationship('BlogInfo', uselist=False, lazy='joined')
    updated_remote = Column(DateTime)
    updated_local = Column(DateTime)
    
class BlogInfo(Base, SerialBase):
    __tablename__ = 'bumblr_blog_info'
    id = Column(Integer, ForeignKey('bumblr_blogs.id'),
                primary_key=True)
    name = Column(Unicode(200), unique=True)
    title = Column(Unicode(500))
    url = Column(Unicode(500))
    description = Column(UnicodeText)
    posts = Column(BigInteger)
    likes = Column(BigInteger)
    followed = Column(Boolean)
    share_likes = Column(Boolean)
    updated = Column(Integer)
    ask = Column(Boolean)
    ask_page_title = Column(Unicode(500))
    ask_anon = Column(Boolean)
    can_send_fan_mail = Column(Boolean)
    is_nsfw = Column(Boolean)
    facebook = Column(Unicode)
    facebook_opengraph_enabled = Column(Unicode)
    twitter_enabled = Column(Boolean)
    tweet = Column(Unicode)
    twitter_send = Column(Boolean)
    
class BlogProperty(Base, SerialBase):
    __tablename__ = 'bumblr_blog_properties'
    blog_id = Column(BigInteger, ForeignKey('bumblr_blogs.id'),
                     primary_key=True)
    property_id = Column(BigInteger,
                         ForeignKey('bumblr_blog_property_names.id'),
                          primary_key=True)

class Photo(Base, SerialBase):
    __tablename__ = 'bumblr_photos'
    id = Column(BigInteger, primary_key=True)
    caption = Column(Unicode)
    exif = Column(PickleType)
    
class PhotoUrl(Base, SerialBase):
    __tablename__ = 'bumblr_photo_urls'
    id = Column(BigInteger, primary_key=True)
    phototype = Column(PhotoType, index=True)
    url = Column(Unicode(500), unique=True)
    width = Column(Integer)
    height = Column(Integer)
    md5sum = Column(String(32))
    request_status = Column(Integer)
    request_head = Column(PickleType)
    keep_local = Column(Boolean, default=False, index=True)
    filename = Column(String, index=True)

class PhotoSize(Base, SerialBase):
    __tablename__ = 'bumblr_photo_sizes'
    photo_id = Column(BigInteger, ForeignKey('bumblr_photos.id'),
                      primary_key=True)
    url_id = Column(BigInteger, ForeignKey('bumblr_photo_urls.id'),
                    primary_key=True)
    
    
class Post(Base, SerialBase):
    __tablename__ = 'bumblr_posts'
    id = Column(BigInteger, primary_key=True)
    blog_name = Column(Unicode(200), index=True)
    post_url = Column(Unicode(500))
    type = Column(Unicode(50))
    timestamp = Column(Integer, index=True)
    date = Column(Unicode(50))
    source_url = Column(Unicode)
    source_title = Column(Unicode)
    liked = Column(Boolean, index=True)
    followed = Column(Boolean, index=True)

class PostContent(Base, SerialBase):
    __tablename__ = 'bumblr_post_content'
    id = Column(BigInteger, ForeignKey('bumblr_posts.id'),
                     primary_key=True)
    content = Column(PickleType)

class BlogPost(Base, SerialBase):
    __tablename__ = 'bumblr_blog_posts'
    blog_id = Column(BigInteger, ForeignKey('bumblr_blogs.id'),
                     primary_key=True)
    post_id = Column(BigInteger, ForeignKey('bumblr_posts.id'),
                     primary_key=True)

class PostPhoto(Base, SerialBase):
    __tablename__ = 'bumblr_post_photos'
    post_id = Column(BigInteger, ForeignKey('bumblr_posts.id'),
                     primary_key=True)
    photo_id = Column(BigInteger, ForeignKey('bumblr_photos.id'),
                          primary_key=True)
    
class LikedPost(Base, SerialBase):
    __tablename__ = 'bumblr_liked_posts'
    blog_id = Column(BigInteger, ForeignKey('bumblr_blogs.id'),
                     primary_key=True)
    post_id = Column(BigInteger, ForeignKey('bumblr_posts.id'),
                     primary_key=True)

class MyLikedPost(Base, SerialBase):
    __tablename__ = 'bumblr_my_liked_posts'
    post_id = Column(BigInteger, ForeignKey('bumblr_posts.id'),
                     primary_key=True)

    

#######################################################
# relationships
#######################################################
