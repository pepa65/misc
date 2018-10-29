#!/usr/bin/env python3
#
# Copyright (C) 2012 Juhamatti Niemelä <iiska@iki.fi>. All Rights Reserved.
# This file is licensed under the GPLv2+.
# <pepa65@passchier.net> 20181028 - Keep more entries as they were
#
# keepassx2pass.py - Convert KeePassX xml export to pass store
# Usage: keepassx2pass.py keepassx.xml

import sys
import re

from subprocess import Popen, PIPE
from xml.etree import ElementTree

def cleanTitle(title):
    """ Convert slashes to underscores """
    return re.sub("(/)", "_", title)

def path_for(element, path=''):
    """ Generate path name from elements title and current path """
    title = element.find('title').text
    if title is None:
        title = ''
    return '/'.join([path, title])

def password_data(element):
    """ Return password data and additional info from password entry """
    passwd = element.find('password').text
    ret = (passwd + "\n") if passwd else "\n"
    for field in ['username', 'url', 'comment']:
        fel = element.find(field)
        children = [(e.text or '') + (e.tail or '') for e in list(fel)]
        if len(children) > 0:
            children.insert(0, '')
        text = (fel.text or '') + "\n".join(children)
        if len(text) > 0:
            ret = "%s%s: %s\n" % (ret, fel.tag, text)
    return ret

def import_entry(element, path=''):
    """ Import new password entry to password-store with pass insert """
    print("Importing " + path_for(element, path))
    proc = Popen(['pass', 'insert', '--multiline', '--force',
                  path_for(element, path)],
                  stdin=PIPE, stdout=PIPE)
    proc.communicate(password_data(element).encode())
    proc.wait()

def import_group(element, path=''):
    """ Import all entries and sub-groups from given group """
    npath = path_for(element, path)
    for group in element.findall('group'):
        import_group(group, npath)
    for entry in element.findall('entry'):
        import_entry(entry, npath)


def main(xml_file):
    """ Parse given KeepassX XML file and import password groups from it """
    for group in ElementTree.parse(xml_file).findall('group'):
        import_group(group)

if __name__ == '__main__':
    main(sys.argv[1])
