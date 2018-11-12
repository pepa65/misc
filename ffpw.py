#!/usr/bin/env python2.7

# ffpw.py - Decode Firefox passwords (https://github.com/lclevy/firepwd)
# lclevy@free.fr - 28 Aug 2013; Oct 2016: logins.json; Feb 2018: key4.db
# Now integrated into https://github.com/AlessandroZ/LaZagne
# Usage: ffpw.py [<options>]
#   options:   -d/--directory <firefox-directory>
#              -p/--password <masterpassword>
#              -v/--verbose
# Required: python-pyasn1 python-pycryptodome

from struct import unpack
import sys
from binascii import hexlify, unhexlify
import sqlite3
from base64 import b64decode
from pyasn1.codec.der import decoder
from hashlib import sha1
import hmac
from Crypto.Cipher import DES3
from Crypto.Util.number import long_to_bytes
from optparse import OptionParser
import json
import os
import glob

def getShortLE(d, a):
  return unpack('<H',(d)[a:a+2])[0]

def getLongBE(d, a):
  return unpack('>L',(d)[a:a+4])[0]

def printASN1(d, l, rl):
  asn1Types = { 0x30: 'SEQUENCE', 4:'OCTETSTRING', 6:'OBJECTIDENTIFIER',
                2: 'INTEGER', 5:'NULL' }
  oidValues = { '2a864886f70d010c050103': '1.2.840.113549.1.12.5.1.3',
                '2a864886f70d0307':'1.2.840.113549.3.7',
                '2a864886f70d010101':'1.2.840.113549.1.1.1' }

  # Minimal 'ASN1 to string' function for displaying Key3.db contents
  type = ord(d[0])
  length = ord(d[1])
  if length&0x80 > 0: # http://luca.ntop.org/Teaching/Appunti/asn1.html,
    nByteLength = length&0x7f
    length = ord(d[2])
    # Long form: 2-127 bytes, first byte: 128+(total number of bytes - 1)
    skip=1
  else:
    skip=0
  #print '%x:%x' % ( type, length )
  print '  '*rl, asn1Types[ type ],
  if type==0x30:
    print '{'
    seqLen = length
    readLen = 0
    while seqLen>0:
      #print seqLen, hexlify(d[2+readLen:])
      len2 = printASN1(d[2+skip+readLen:], seqLen, rl+1)
      #print 'l2=%x' % len2
      seqLen = seqLen - len2
      readLen = readLen + len2
    print '  '*rl,'}'
    return length+2
  elif type==6: # OID
    print oidValues[ hexlify(d[2:2+length]) ]
    return length+2
  elif type==4: # OCTETSTRING
    print hexlify( d[2:2+length] )
    return length+2
  elif type==5: # NULL
    print 0
    return length+2
  elif type==2: # INTEGER
    print hexlify( d[2:2+length] )
    return length+2
  else:
    if length==l-2:
      printASN1( d[2:], length, rl+1)
      return length

# Extract records from a BSD DB 1.85, hash mode (key3.db)
# Obsolete with Firefox 58.0.2+ and NSS 3.35+: key4.db (SQLite) is used
def readBsddb(name):
  f = open(name,'rb')
  # http://download.oracle.com/berkeley-db/db.1.85.tar.gz
  header = f.read(4*15)
  magic = getLongBE(header,0)
  if magic != 0x61561:
    print 'bad magic number'
    sys.exit()
  version = getLongBE(header,4)
  if version !=2:
    print 'bad version, !=2 (1.85)'
    sys.exit()
  pagesize = getLongBE(header,12)
  nkeys = getLongBE(header,0x38)
  if options.verbose>1:
    print 'pagesize=0x%x' % pagesize
    print 'nkeys=%d' % nkeys

  readkeys = 0
  page = 1
  nval = 0
  val = 1
  db1 = []
  while (readkeys < nkeys):
    f.seek(pagesize*page)
    offsets = f.read((nkeys+1)* 4 +2)
    offsetVals = []
    i=0
    nval = 0
    val = 1
    keys = 0
    while nval != val :
      keys +=1
      key = getShortLE(offsets,2+i)
      val = getShortLE(offsets,4+i)
      nval = getShortLE(offsets,8+i)
      #print 'key=0x%x, val=0x%x' % (key, val)
      offsetVals.append(key+ pagesize*page)
      offsetVals.append(val+ pagesize*page)
      readkeys += 1
      i += 4
    offsetVals.append(pagesize*(page+1))
    valKey = sorted(offsetVals)
    for i in range( keys*2 ):
      #print '%x %x' % (valKey[i], valKey[i+1])
      f.seek(valKey[i])
      data = f.read(valKey[i+1] - valKey[i])
      db1.append(data)
    page += 1
    #print 'offset=0x%x' % (page*pagesize)
  f.close()
  db = {}

  for i in range( 0, len(db1), 2):
    db[ db1[i+1] ] = db1[ i ]
  if options.verbose>1:
    for i in db:
      print '%s: %s' % ( repr(i), hexlify(db[i]) )
  return db

def decrypt3DES( globalSalt, masterPassword, entrySalt, encryptedData ):
  # http://www.drh-consultancy.demon.co.uk/key3.html
  hp = sha1( globalSalt+masterPassword ).digest()
  pes = entrySalt + '\x00'*(20-len(entrySalt))
  chp = sha1( hp+entrySalt ).digest()
  k1 = hmac.new(chp, pes+entrySalt, sha1).digest()
  tk = hmac.new(chp, pes, sha1).digest()
  k2 = hmac.new(chp, tk+entrySalt, sha1).digest()
  k = k1+k2
  iv = k[-8:]
  key = k[:24]
  if options.verbose>0:
    print 'key='+hexlify(key), 'iv='+hexlify(iv)
  return DES3.new( key, DES3.MODE_CBC, iv).decrypt(encryptedData)

def decodeLoginData(data):
  asn1data = decoder.decode(b64decode(data))
  # For login and password keep: key_id, iv, ciphertext
  return asn1data[0][0].asOctets(), asn1data[0][1][1].asOctets(), \
    asn1data[0][2].asOctets()

def getLoginData():
  conn = sqlite3.connect(options.directory+'signons.sqlite')
  logins = []
  c = conn.cursor()
  try:
    c.execute("SELECT * FROM moz_logins;")
  # Since Firefox 32, json is used instead of sqlite3
  except sqlite3.OperationalError:
    loginf = open(options.directory+'logins.json','r').read()
    jsonLogins = json.loads(loginf)
    if 'logins' not in jsonLogins:
      print 'error: no \'logins\' key in logins.json'
      return []
    for row in jsonLogins['logins']:
      encUsername = row['encryptedUsername']
      encPassword = row['encryptedPassword']
      logins.append((decodeLoginData(encUsername), decodeLoginData(encPassword), row['hostname']))
    return logins
  # Using sqlite3 database
  for row in c:
    encUsername = row[6]
    encPassword = row[7]
    if options.verbose>1:
      print row[1], encUsername, encPassword
    logins.append( (decodeLoginData(encUsername), decodeLoginData(encPassword), row[1]) )
  return logins

def extractSecretKey(masterPassword, keyData):
  # http://www.drh-consultancy.demon.co.uk/key3.html
  pwdCheck = keyData['password-check']
  if options.verbose>1:
    print 'password-check='+hexlify(pwdCheck)
  entrySaltLen = ord(pwdCheck[1])
  entrySalt = pwdCheck[3: 3+entrySaltLen]
  if options.verbose>1:
    print 'entrySalt=%s' % hexlify(entrySalt)
  encryptedPasswd = pwdCheck[-16:]
  globalSalt = keyData['global-salt']
  if options.verbose>1:
    print 'globalSalt=%s' % hexlify(globalSalt)
  cleartextData = decrypt3DES( globalSalt, masterPassword, entrySalt, encryptedPasswd )
  if cleartextData != 'password-check\x02\x02':
    print 'password check error, Master Password is certainly used, please provide it with -p option'
    sys.exit()

  if unhexlify('f8000000000000000000000000000001') not in keyData:
    return None
  privKeyEntry = keyData[ unhexlify('f8000000000000000000000000000001') ]
  saltLen = ord( privKeyEntry[1] )
  nameLen = ord( privKeyEntry[2] )
  #print 'saltLen=%d nameLen=%d' % (saltLen, nameLen)
  privKeyEntryASN1 = decoder.decode( privKeyEntry[3+saltLen+nameLen:] )
  data = privKeyEntry[3+saltLen+nameLen:]
  ##printASN1(data, len(data), 0)
  # https://github.com/philsmd/pswRecovery4Moz/blob/master/pswRecovery4Moz.txt
  entrySalt = privKeyEntryASN1[0][0][1][0].asOctets()
  if options.verbose>0:
    print 'entrySalt=%s' % hexlify(entrySalt)
  privKeyData = privKeyEntryASN1[0][1].asOctets()
  if options.verbose>0:
    print 'privKeyData=%s' % hexlify(privKeyData)
  privKey = decrypt3DES( globalSalt, masterPassword, entrySalt, privKeyData )
  ##print 'decrypting privKeyData'
  if options.verbose>0:
    print 'decrypted=%s' % hexlify(privKey)
  ##printASN1(privKey, len(privKey), 0)

  privKeyASN1 = decoder.decode( privKey )
  prKey= privKeyASN1[0][2].asOctets()
  ##print 'decoding %s' % hexlify(prKey)
  ##printASN1(prKey, len(prKey), 0)
  prKeyASN1 = decoder.decode( prKey )
  id = prKeyASN1[0][1]
  key = long_to_bytes( prKeyASN1[0][3] )
  if options.verbose>0:
    print 'key=%s' % ( hexlify(key) )
  return key

def getKey():
  # firefox 58.0.2+ / NSS 3.35+ with key4.db in SQLite
  conn = sqlite3.connect(options.directory+'key4.db')
  c = conn.cursor()
  try:
    # First check password
    c.execute("SELECT item1,item2 FROM metadata WHERE id = 'password';")
    row = c.next()
    globalSalt = row[0] # item1
    item2 = row[1]
    ##printASN1(item2, len(item2), 0)
    """
     SEQUENCE {
       SEQUENCE {
         OBJECTIDENTIFIER 1.2.840.113549.1.12.5.1.3
         SEQUENCE {
           OCTETSTRING entry_salt_for_passwd_check
           INTEGER 01
         }
       }
       OCTETSTRING encrypted_password_check
     }
    """
    decodedItem2 = decoder.decode( item2 )
    entrySalt = decodedItem2[0][0][1][0].asOctets()
    cipherT = decodedItem2[0][1].asOctets()
    # Usual Mozilla PBE
    clearText = decrypt3DES( globalSalt, options.masterPassword, entrySalt, cipherT )
    ##print 'password check?', clearText=='password-check\x02\x02'
    if clearText=='password-check\x02\x02':
      # Decrypt 3des key to decrypt "logins.json" content
      c.execute("SELECT a11,a102 FROM nssPrivate;")
      row = c.next()
      a11 = row[0] # CKA_VALUE
      a102 = row[1] # f8000000000000000000000000000001, CKA_ID
      ##printASN1( a11, len(a11), 0)
      """
       SEQUENCE {
         SEQUENCE {
           OBJECTIDENTIFIER 1.2.840.113549.1.12.5.1.3
           SEQUENCE {
             OCTETSTRING entry_salt_for_3des_key
             INTEGER 01
           }
         }
         OCTETSTRING encrypted_3des_key (with 8 bytes of PKCS#7 padding)
       }
      """
      decodedA11 = decoder.decode( a11 )
      entrySalt = decodedA11[0][0][1][0].asOctets()
      cipherT = decodedA11[0][1].asOctets()
      key = decrypt3DES( globalSalt, options.masterPassword, entrySalt, cipherT )
      #print '3deskey', hexlify(key)
  except:
    keyData = readBsddb(options.directory+'key3.db')
    key = extractSecretKey(options.masterPassword, keyData)
  try:
    key
  except:
    print "ABORT: Masterpassword needed, specify after '-p'"
    sys.exit(1)
  return key[:24]

dirs = glob.glob(os.getenv('HOME')+'/.mozilla/firefox/*.default/')
parser = OptionParser(usage="usage: %prog [options]")
parser.add_option("-v", "--verbose", type="int", dest="verbose", help="verbose level", default=0)
parser.add_option("-p", "--password", type="string", dest="masterPassword", help="masterPassword", default='')
parser.add_option("-d", "--directory", type="string", dest="directory", help="directory", default=dirs[0])
(options, args) = parser.parse_args()

def unpad(text):
  '''
  Remove quotes and stringified PKCS#7 padding from text
  '''
  return text[1:(len(text)-4*(ord(text[-2:-1])-48)-1)]

key = getKey()
logins = getLoginData()
for i in logins:
  if i[2] == "chrome://FirefoxAccounts":
    continue
  print i[2],
  print unpad(repr(DES3.new(key, DES3.MODE_CBC, i[0][1]).decrypt(i[0][2]))),
  print unpad(repr(DES3.new(key, DES3.MODE_CBC, i[1][1]).decrypt(i[1][2])))
