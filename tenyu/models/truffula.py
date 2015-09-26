from datetime import datetime, date
import time

from sqlalchemy import Sequence, Column, ForeignKey

# column types
from sqlalchemy import Integer, String, Unicode
from sqlalchemy import Boolean, Date, LargeBinary
from sqlalchemy import PickleType
from sqlalchemy import Enum
from sqlalchemy import DateTime

from sqlalchemy.orm import relationship, backref

from sqlalchemy.ext.declarative import declarative_base

from chert.alchemy import SerialBase, TimeStampMixin


# Truffula gets it's own database
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()


####################################
## Data Types                     ##
####################################

SimpleDescriptionType = Enum('flower', 'leaf', 'form', 'fruit',
                             'bark', 'twig',
                             name='truffula_simple_description_type_enum')

VTPictureType = Enum('flower', 'leaf', 'form', 'fruit',
                             'bark', 'twig', 'map',
                             name='vt_picture_type_enum')

####################################
## Tables                         ##
####################################

class URI(SerialBase, Base):
    __tablename__ = 'trf_global_uri_table'
    id = Column(Integer, primary_key=True)
    identifier = Column(Unicode, unique=True)
    headers = Column(PickleType)
    created = Column(DateTime)
    updated = Column(DateTime)


class Genus(SerialBase, Base):
    __tablename__ = 'trf_genus_list'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode, unique=True)

class GenusWiki(SerialBase, Base):
    __tablename__ = 'trf_genus_wikipages'
    id = Column(Integer, ForeignKey('trf_genus_list.id'), primary_key=True)
    content = Column(Unicode)

class SpecName(SerialBase, Base):
    __tablename__ = 'trf_species_list'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode, unique=True)
    

class Species(SerialBase, Base):
    __tablename__ = 'trf_species_table'
    genus_id = Column(Integer,
                      ForeignKey('trf_genus_list.id'), primary_key=True)
    spec_id = Column(Integer,
                     ForeignKey('trf_species_list.id'), primary_key=True)
    cname = Column(Unicode)

class SimpleDescription(SerialBase, Base):
    __tablename__ = 'trf_simple_descriptions'
    id = Column(Integer, primary_key=True)
    type = Column(SimpleDescriptionType)
    text = Column(Unicode)
    

class VTSpecies(SerialBase, Base):
    __tablename__ = 'trf_vt_species_table'
    id = Column(Integer, primary_key=True)
    genus_id = Column(Integer, ForeignKey('trf_genus_list.id'))
    spec_id = Column(Integer, ForeignKey('trf_species_list.id'))
    cname = Column(Unicode)
    symbol = Column(Unicode)
    flower = Column(Unicode)
    leaf = Column(Unicode)
    form = Column(Unicode)
    fruit = Column(Unicode)
    bark = Column(Unicode)
    twig = Column(Unicode)
    data = Column(PickleType)
    wikipage = Column(Unicode)
    
class VTLooksLike(SerialBase, Base):
    __tablename__ = 'trf_vt_looks_likes'
    spec_id = Column(Integer,
                     ForeignKey('trf_vt_species_table.id'), primary_key=True)
    like_id = Column(Integer,
                     ForeignKey('trf_vt_species_table.id'), primary_key=True)

class VTPicture(SerialBase, Base):
    __tablename__ = 'trf_vt_pictures'
    id = Column(Integer,
                ForeignKey('trf_vt_species_table.id'), primary_key=True)
    type = Column(VTPictureType, primary_key=True)
    #text = Column(Unicode)
    url = Column(Unicode)
    
class WikiPage(SerialBase, Base):
    __tablename__ = 'trf_wiki_pages'
    id = Column(Integer, primary_key=True)
    name = Column(Unicode, unique=True)
    title = Column(Unicode)
    content = Column(Unicode)
    
#VTSpecies.like = relationship('vt_looks_likes.spec_id')
from sqlalchemy.orm.collections import attribute_mapped_collection

Genus.wiki = relationship(GenusWiki, uselist=False)

VTSpecies.pictures = relationship(
    VTPicture,
    collection_class=attribute_mapped_collection('type'))

VTSpecies.genus = relationship(Genus)
VTSpecies.species = relationship(SpecName)
VTSpecies.looklikes = relationship(
    VTSpecies,
    secondary='trf_vt_looks_likes',
    primaryjoin=VTSpecies.id==VTLooksLike.spec_id,
    secondaryjoin=VTSpecies.id==VTLooksLike.like_id)

    
