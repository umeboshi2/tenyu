import os
from ConfigParser import ConfigParser
from StringIO import StringIO
from datetime import datetime

from PIL import Image
from sqlalchemy.orm.exc import NoResultFound
import transaction

from chert.urlrepo import ImageRepo

from trumpet.managers.base import GetByNameManager

from tenyu.models.sitecontent import SiteImage

DEFAULT_THUMBNAIL_SIZE = 128, 128

FORMAT_EXTENSIONS = dict(JPEG='jpeg', PNG='png')

class FilenameInDatabaseError(Exception):
    pass

class ImageFileExistsError(Exception):
    pass



def make_thumbnail(content, thumbnail_size=DEFAULT_THUMBNAIL_SIZE):
    imgfile = StringIO(content)
    img = Image.open(imgfile)
    img.thumbnail(thumbnail_size, Image.ANTIALIAS)
    outfile = StringIO()
    img.save(outfile, 'JPEG')
    outfile.seek(0)
    thumbnail_content = outfile.read()
    return thumbnail_content

class SiteImageManager(GetByNameManager):
    dbmodel = SiteImage
    def __init__(self, session, images_directory):
        self.session = session
        self.thumbnail_size = DEFAULT_THUMBNAIL_SIZE
        self.imagepath = images_directory
        self.imagerepo = ImageRepo(self.imagepath)
        
    def get_by_name_query(self, name):
        return self.query().filter_by(checksum=name)
    
    def make_thumbnail(self, content):
        return make_thumbnail(content)

    def add_image(self, name, fileobj):
        content = fileobj.read()
        checksum = self.imagerepo.get_checksum_content(content)
        ifile = StringIO(content)
        img = Image.open(ifile)
        if img.format in FORMAT_EXTENSIONS:
            ext = FORMAT_EXTENSIONS[img.format]
        else:
            raise RuntimeError, "Unable to determine image type"
        underscored = name.replace(' ', '_')
        filename = underscored
        if not filename.endswith('.%s' % ext):
            filename = '%s.%s' % (underscored, ext)
        if self.get_by_name(filename) is not None:
            raise FilenameInDatabaseError, "%s already exists." % filename

        #localpath = self.imagerepo.
        if self.imagerepo.file_exists(checksum, ext):
            msg = "File %s already exists on filesystem." % checksum
            raise ImageFileExistsError, msg
        self.imagerepo.import_content(content, ext)
        if not self.imagerepo.file_exists(checksum, ext):
            raise RuntimeError, "Problem creating %s" % checksum
        with transaction.manager:
            image = SiteImage()
            image.checksum = checksum
            image.thumbnail = make_thumbnail(content)
            image.ext = ext
            self.session.add(image)
        return self.session.merge(image)

    def delete_image(self, id):
        with transaction.manager:
            image = self.session.query(SiteImage).get(id)
            image.delete()

    def delete_everything(self):
        with transaction.manager:
            self.session.query(SiteImage).delete()
        self.imagerepo.delete_all()
        

            
            
