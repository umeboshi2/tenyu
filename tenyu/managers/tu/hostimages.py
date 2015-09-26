from cStringIO import StringIO

import transaction
from PIL import Image


from trumpet.models.sitecontent import SiteImage

from tenyu.models.tu.content import HostImage



class HostImageManager(object):
    def __init__(self, session, user_id):
        self.session = session
        self.user_id = user_id
        self.thumbnail_size = 128, 128
        
    def images_query(self):
        return self.session.query(HostImage).filter_by(user_id=self.user_id)
        
        
    def make_thumbnail(self, content):
        imgfile = StringIO(content)
        img = Image.open(imgfile)
        img.thumbnail(self.thumbnail_size, Image.ANTIALIAS)
        outfile = StringIO()
        img.save(outfile, 'JPEG')
        outfile.seek(0)
        thumbnail_content = outfile.read()
        return thumbnail_content
    
    def add_image(self, name, fileobj):
        content = fileobj.read()
        with transaction.manager:
            image = SiteImage(name, content)
            image.thumbnail = self.make_thumbnail(content)
            self.session.add(image)
            image = self.session.merge(image)
            hostimage = HostImage(self.user_id, image.id)
            self.session.add(hostimage)
        return self.session.merge(hostimage)
    
    def delete_image(self, id):
        with transaction.manager:
            himage = self.session.query(HostImage).get((self.user_id, id))
            #.get(image_id=id,
            #        user_id=self.user_id)
            image = self.session.query(SiteImage).get(id)
            for i in himage, image:
                self.session.delete(i)

