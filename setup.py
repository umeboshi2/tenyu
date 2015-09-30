import os

from setuptools import setup, find_packages

# libjpeg-dev
# libopenjpeg-dev
# libtiff5-dev
# libfreetype6-dev
# liblcms2-dev
# libwebp-dev
# tk-dev
# libxml2-dev
# libxslt1-dev
# libev-dev


requires = [
    'trumpet',
    ]

setup(name='tenyu',
      version='0.0',
      description='tenyu',
      long_description="tenyu is five double u's",
      classifiers=[
        "Programming Language :: Python",
        "Framework :: Pyramid",
        "Topic :: Internet :: WWW/HTTP",
        "Topic :: Internet :: WWW/HTTP :: WSGI :: Application",
        ],
      author='',
      author_email='',
      url='',
      keywords='web wsgi bfg pylons pyramid',
      packages=find_packages(),
      include_package_data=True,
      zip_safe=False,
      test_suite='tenyu',
      install_requires=requires,
      entry_points="""\
      [paste.app_factory]
      main = tenyu:main
      [console_scripts]
      initialize_tenyu_db = tenyu.scripts.initializedb:main
      """,
      dependency_links=[
        'https://github.com/knowah/PyPDF2/archive/master.tar.gz#egg=PyPDF2-1.15dev',
        'https://github.com/umeboshi2/trumpet/archive/master.tar.gz#egg=trumpet',
        ]
      )
