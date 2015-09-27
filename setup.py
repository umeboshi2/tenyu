import os

from setuptools import setup, find_packages

requires = [
    'SQLAlchemy',
    'psycopg2',        # dbapi for postgresql
    'transaction',     # I am not sure if I should use this or not
    'pyramid',
    'pyramid_tm',
    'pyramid_debugtoolbar',
    'zope.sqlalchemy',
    'pyramid-beaker',
    'pyramid-mako',
    'waitress',
    'requests',
    'cornice',
    'beautifulsoup4',
    'lxml',
    'mechanize',
    # testing
    'celery',
    
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
