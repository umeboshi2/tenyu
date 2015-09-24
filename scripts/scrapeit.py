#!/usr/bin/env python
import os, sys
import cPickle as Pickle

from tenyu.scrapers.silvicstoc import SilvicsToCCollector
from tenyu.scrapers.wikipedia import WikiCollector
from tenyu.scrapers.vtdendro import VTDendroCollector
from tenyu.scrapers.saylor import SaylorIndexCollector

from tenyu.scrapers.wikipedia import get_wikipedia_pages_for_vt
from tenyu.scrapers.wikipedia import get_wikipedia_pages_for_silvics

cachedir = 'tdata'

vc = VTDendroCollector(cachedir=cachedir)

GENUS_MISSPELLS = dict(manilkara='manikara')
SPECIES_MISSPELLS = dict(
    nyssa=dict(
        sylvatica='silvatica'),
    carya=dict(
        myristiciformis='myristicformis',
        illinoinensis='illinoesis'),
    cedrela=dict(
        odorata='ordota'),
    magnolia=dict(
        acuminata='accuminata'))

if 'SKIP_VTDENDRO_SCRAPE' not in os.environ:
    print "Getting vtdendro info..."
    vc.get_tree_pages()
    vc.add_trees()
    get_wikipedia_pages_for_vt(vc.trees, cachedir=cachedir)
    print "Downloading VTDendro Pictures"
    vc.download_pictures()

if 'SKIP_SILVICS_SCRAPE' not in os.environ:
    print "Getting silvics info..."
    sc = SilvicsToCCollector(cachedir=cachedir)
    wc = WikiCollector(cachedir=cachedir)
    sc.get_link_info()
    get_wikipedia_pages_for_silvics(sc.trees, cachedir=cachedir)

syc = SaylorIndexCollector(cachedir=cachedir)
syc.get_plant_anchors()

