-- PostgreSQL compatible tests from inet
-- 180 tests

-- Test 1: query (line 4)
SELECT '192.168.1.2/24':::INET;

-- Test 2: query (line 9)
SELECT '192.168.1.2/32':::INET;

-- Test 3: query (line 14)
SELECT '192.168.1.2':::INET;

-- Test 4: query (line 19)
SELECT '192.168.1.2/24':::INET;

-- Test 5: query (line 24)
SELECT '0.0.0.0':::INET;

-- Test 6: query (line 29)
SELECT '::/0'::inet::text::inet;

-- Test 7: query (line 36)
SELECT '::ffff:192.168.1.2':::INET;

-- Test 8: query (line 41)
SELECT '::ffff:192.168.1.2/120':::INET;

-- Test 9: query (line 46)
SELECT '::ffff':::INET;

-- Test 10: query (line 51)
SELECT '2001:4f8:3:ba:2e0:81ff:fe22:d1f1/120':::INET;

-- Test 11: query (line 56)
SELECT '2001:4f8:3:ba:2e0:81ff:fe22:d1f1':::INET;

-- Test 12: query (line 63)
SELECT '192.168.1.2/24'::INET;

-- Test 13: query (line 69)
SELECT '192.168.1.200/10':::INET

-- Test 14: query (line 76)
SELECT '192.168.1/10':::INET

-- Test 15: query (line 81)
SELECT '192.168/10':::INET

-- Test 16: query (line 86)
SELECT '192/10':::INET

-- Test 17: query (line 93)
SELECT '255/10':::INET

-- Test 18: statement (line 100)
SELECT '192':::INET

-- Test 19: statement (line 103)
SELECT '19.0':::INET

-- Test 20: statement (line 108)
SELECT '19.0/32':::INET

-- Test 21: statement (line 111)
SELECT '19/32':::INET

-- Test 22: statement (line 114)
SELECT '19/16':::INET

-- Test 23: query (line 117)
SELECT '19/15':::INET

-- Test 24: statement (line 124)
SELECT '192.168/24/1':::INET

-- Test 25: statement (line 127)
SELECT '':::INET

-- Test 26: statement (line 130)
SELECT '0':::INET

-- Test 27: query (line 133)
SELECT '0.0.0.0':::INET

-- Test 28: query (line 140)
SELECT '::ffff:192.168.0.1/24'::INET = '::ffff:192.168.0.1/24'::INET

-- Test 29: query (line 145)
SELECT '::ffff:192.168.0.1/24'::INET = '::ffff:192.168.0.1/25'::INET

-- Test 30: query (line 150)
SELECT '::ffff:192.168.0.1/24'::INET = '::ffff:192.168.0.1'::INET

-- Test 31: query (line 155)
SELECT '::ffff:192.168.0.1'::INET = '::ffff:192.168.0.1'::INET

-- Test 32: query (line 162)
SELECT '::ffff:192.168.0.1'::INET = '192.168.0.1'::INET

-- Test 33: query (line 167)
SELECT '192.168.0.1'::INET = '192.168.0.1'::INET

-- Test 34: query (line 172)
SELECT '192.168.0.1/0'::INET = '192.168.0.1'::INET

-- Test 35: query (line 177)
SELECT '192.168.0.1/0'::INET = '192.168.0.1/0'::INET

-- Test 36: query (line 182)
SELECT '192.168.0.1/0'::INET = '192.168.0.1/0'::INET

-- Test 37: query (line 189)
SELECT '192.168.0.2/24'::INET < '192.168.0.1/25'::INET

-- Test 38: query (line 194)
SELECT '1.2.3.4':::INET < '1.2.3.5':::INET

-- Test 39: query (line 199)
SELECT '192.168.0.1/0'::INET > '192.168.0.1/0'::INET

-- Test 40: query (line 204)
SELECT '192.168.0.0'::INET > '192.168.0.1/0'::INET

-- Test 41: query (line 209)
SELECT '::ffff:1.2.3.4':::INET > '1.2.3.4':::INET

-- Test 42: query (line 216)
SELECT '192.168.200.95/17'::INET >> '192.168.162.1'::INET

-- Test 43: query (line 221)
SELECT '192.168.200.95/8'::INET >> '192.168.2.1/8'::INET

-- Test 44: query (line 226)
SELECT '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET >> '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET

-- Test 45: query (line 231)
SELECT '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET >> '2001:0db8:0000:0000:0000:0000:0000:0001/100'::INET

-- Test 46: query (line 236)
SELECT '192.168.200.95/8'::INET >>= '192.168.2.1/8'::INET

-- Test 47: query (line 241)
SELECT '192.168.200.95/17'::INET >>= '192.168.2.1/24'::INET

-- Test 48: query (line 246)
SELECT '192.168.200.95/8'::INET >>= '192.168.2.1/8'::INET

-- Test 49: query (line 251)
SELECT '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET >>= '2001:0db8:0000:0000:0000:0000:0000:0001/100'::INET

-- Test 50: query (line 256)
SELECT '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET >>= '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET

-- Test 51: query (line 261)
SELECT '192.168.200.95'::INET << '192.168.2.1/8'::INET

-- Test 52: query (line 266)
SELECT '192.168.200.95/8'::INET << '192.168.2.1/8'::INET

-- Test 53: query (line 271)
SELECT '192.168.200.95'::INET <<= '192.168.2.1/8'::INET

-- Test 54: query (line 276)
SELECT '192.168.200.95/8'::INET <<= '192.168.2.1/8'::INET

-- Test 55: query (line 281)
SELECT '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET << '2001:0db8:0000:0000:0000:0000:0000:0001/100'::INET

-- Test 56: query (line 286)
SELECT '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET << '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET

-- Test 57: query (line 291)
SELECT '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET <<= '2001:0db8:0000:0000:0000:0000:0000:0001/100'::INET

-- Test 58: query (line 296)
SELECT '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET <<= '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET

-- Test 59: query (line 301)
SELECT '192.168.200.95/16'::INET && '192.168.2.1/24'::INET

-- Test 60: query (line 306)
SELECT '192.168.200.95/17'::INET && '192.168.2.1/24'::INET

-- Test 61: query (line 311)
SELECT '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET && '2001:0db8:0000:0000:0000:0000:0000:0001/100'::INET

-- Test 62: query (line 316)
SELECT '2001:0db8:0000:0000:0500:5000:0000:0001/50'::INET && '2001:0db8:0000:0000:0000:0000:0000:0001/100'::INET

-- Test 63: query (line 321)
SELECT '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET >> '192.168.2.1/8'::INET

-- Test 64: query (line 326)
SELECT '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET >>= '192.168.2.1/8'::INET

-- Test 65: query (line 331)
SELECT '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET << '192.168.2.1/8'::INET

-- Test 66: query (line 336)
SELECT '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET <<= '192.168.2.1/8'::INET

-- Test 67: query (line 341)
SELECT '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET && '192.168.2.1/8'::INET

-- Test 68: query (line 346)
SELECT '192.168.2.1/8'::INET >> '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET

-- Test 69: query (line 351)
SELECT '192.168.2.1/8'::INET >>= '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET

-- Test 70: query (line 356)
SELECT '192.168.2.1/8'::INET << '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET

-- Test 71: query (line 361)
SELECT '192.168.2.1/8'::INET <<= '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET

-- Test 72: query (line 366)
SELECT '192.168.2.1/8'::INET && '2001:0db8:0500:0000:0500:5000:0000:0001/50'::INET

-- Test 73: query (line 373)
SELECT ~'192.168.1.2/10':::INET

-- Test 74: query (line 378)
SELECT ~'192.168.1.2/0':::INET

-- Test 75: query (line 383)
SELECT ~'2001:4f8:3:ba::/64':::INET

-- Test 76: query (line 388)
SELECT '255.255.255.250/2':::INET & '0.5.0.5/17':::INET

-- Test 77: query (line 393)
SELECT '0000:0564:0000:0aab:0000:0000:0060:0005/23':::INET & 'ffff:ffff:ffff:ffff:ffff:ffff:ffff:0005/123':::INET

-- Test 78: query (line 398)
SELECT '192.168.1.2/1':::INET | '192.168.1.3/17':::INET

-- Test 79: query (line 403)
SELECT '6e32:8a01:373b:c9ce:8ed5:9f7f:dc7e:5cfc/99':::INET | 'c33e:9867:5c98:f0a2:2b2:abf9:c7a5:67d':::INET

-- Test 80: statement (line 408)
SELECT '0000:0564:0000:0aab:0000:0000:0060:0005/23':::INET & '192.168.1.2/1':::INET

-- Test 81: statement (line 411)
SELECT '0000:0564:0000:0aab:0000:0000:0060:0005/23':::INET | '192.168.1.2/1':::INET

-- Test 82: query (line 416)
SELECT '192.168.1.2':::INET + 184836468

-- Test 83: query (line 421)
SELECT '0.0.0.5':::INET - 5

-- Test 84: query (line 426)
SELECT '203.172.98.118/23':::INET - 184836468

-- Test 85: query (line 431)
SELECT '0.0.0.5':::INET - -5

-- Test 86: query (line 436)
SELECT '::4104:4066:5de7:b1fa':::INET - 4684658846864486648

-- Test 87: query (line 441)
SELECT '::4104:4066:5de7:b1fa/121':::INET + -4684658846864486648

-- Test 88: query (line 446)
SELECT '::4104:4066:5de7:b1fa/101':::INET + 2

-- Test 89: query (line 451)
SELECT '::5/128':::INET - -2

-- Test 90: query (line 456)
SELECT '203.172.98.118/17':::INET - '192.168.1.2/1':::INET

-- Test 91: query (line 461)
SELECT '::4104:4066:5de7:b1fa/79':::INET - '::ffff:192.168.1.2/44':::INET

-- Test 92: statement (line 466)
SELECT '255.255.0.5':::INET + 2000000000

-- Test 93: statement (line 469)
SELECT '0.0.0.5':::INET - 10

-- Test 94: statement (line 472)
SELECT '::5/128':::INET - 10

-- Test 95: statement (line 475)
SELECT 'ff00:5::/128':::INET - '::ff00:5/128':::INET

-- Test 96: query (line 480)
SELECT '0.0.0.0.':::INET

-- Test 97: statement (line 485)
SELECT '.0.0.0.0.':::INET

-- Test 98: statement (line 488)
SELECT '0.0.0.0.0':::INET

-- Test 99: statement (line 493)
CREATE TABLE u (ip inet PRIMARY KEY,
                ip2 inet)

-- Test 100: statement (line 497)
INSERT INTO u VALUES ('192.168.0.1', '192.168.0.1')

-- Test 101: statement (line 500)
INSERT INTO u VALUES ('192.168.0.1', '192.168.0.2')

-- Test 102: statement (line 503)
INSERT INTO u VALUES ('192.168.0.2', '192.168.0.2')

-- Test 103: statement (line 506)
INSERT INTO u VALUES ('192.168.0.5/24', '192.168.0.5')

-- Test 104: statement (line 509)
INSERT INTO u VALUES ('192.168.0.1/31', '192.168.0.1')

-- Test 105: statement (line 512)
INSERT INTO u VALUES ('192.168.0.0', '192.168.0.1')

-- Test 106: statement (line 515)
INSERT INTO u VALUES ('192.0.0.0', '127.0.0.1')

-- Test 107: statement (line 518)
INSERT INTO u (ip) VALUES ('::1')

-- Test 108: statement (line 521)
INSERT INTO u (ip) VALUES ('::ffff:1.2.3.4')

-- Test 109: query (line 524)
SELECT * FROM u ORDER BY ip

-- Test 110: statement (line 536)
CREATE TABLE arrays (ips INET[])

-- Test 111: statement (line 539)
INSERT INTO arrays VALUES
    (ARRAY[]),
    (ARRAY['192.168.0.1/10', '::1']),
    (ARRAY['192.168.0.1', '192.168.0.1/10', '::1', '::ffff:1.2.3.4'])

-- Test 112: query (line 545)
SELECT * FROM arrays

-- Test 113: query (line 560)
SELECT abbrev('10.1.0.0/16'::INET)

-- Test 114: query (line 565)
SELECT abbrev('192.168.0.1/16'::INET)

-- Test 115: query (line 570)
SELECT abbrev('192.168.0.1'::INET)

-- Test 116: query (line 575)
SELECT abbrev('192.168.0.1/32'::INET)

-- Test 117: query (line 580)
SELECT abbrev('10.0/16'::INET)

-- Test 118: query (line 585)
SELECT abbrev('::ffff:192.168.0.1'::INET)

-- Test 119: query (line 590)
SELECT abbrev('::ffff:192.168.0.1/24'::INET)

-- Test 120: query (line 597)
SELECT broadcast('10.1.0.0/16'::INET)

-- Test 121: query (line 602)
SELECT broadcast('192.168.0.1/16'::INET)

-- Test 122: query (line 607)
SELECT broadcast('192.168.0.1'::INET)

-- Test 123: query (line 612)
SELECT broadcast('192.168.0.1/32'::INET)

-- Test 124: query (line 617)
SELECT broadcast('::ffff:192.168.0.1'::INET)

-- Test 125: query (line 622)
SELECT broadcast('::ffff:1.2.3.1/20'::INET)

-- Test 126: query (line 627)
SELECT broadcast('2001:4f8:3:ba::/64'::INET)

-- Test 127: query (line 634)
SELECT family('10.1.0.0/16'::INET)

-- Test 128: query (line 639)
SELECT family('192.168.0.1/16'::INET)

-- Test 129: query (line 644)
SELECT family('192.168.0.1'::INET)

-- Test 130: query (line 649)
SELECT family('::ffff:192.168.0.1'::INET)

-- Test 131: query (line 654)
SELECT family('::ffff:1.2.3.1/20'::INET)

-- Test 132: query (line 659)
SELECT family('2001:4f8:3:ba::/64'::INET)

-- Test 133: query (line 666)
SELECT host('10.1.0.0/16'::INET)

-- Test 134: query (line 671)
SELECT host('192.168.0.1/16'::INET)

-- Test 135: query (line 676)
SELECT host('192.168.0.1'::INET)

-- Test 136: query (line 681)
SELECT host('192.168.0.1/32'::INET)

-- Test 137: query (line 686)
SELECT host('::ffff:192.168.0.1'::INET)

-- Test 138: query (line 691)
SELECT host('::ffff:192.168.0.1/24'::INET)

-- Test 139: query (line 698)
SELECT hostmask('192.168.1.2'::INET)

-- Test 140: query (line 703)
SELECT hostmask('192.168.1.2/16'::INET)

-- Test 141: query (line 708)
SELECT hostmask('192.168.1.2/10'::INET)

-- Test 142: query (line 713)
SELECT hostmask('2001:4f8:3:ba::/64'::INET)

-- Test 143: query (line 720)
SELECT masklen('192.168.1.2'::INET)

-- Test 144: query (line 725)
SELECT masklen('192.168.1.2/16'::INET)

-- Test 145: query (line 730)
SELECT masklen('192.168.1.2/10'::INET)

-- Test 146: query (line 735)
SELECT masklen('2001:4f8:3:ba::/64'::INET)

-- Test 147: query (line 740)
SELECT masklen('2001:4f8:3:ba::'::INET)

-- Test 148: query (line 747)
SELECT netmask('192.168.1.2'::INET)

-- Test 149: query (line 752)
SELECT netmask('192.168.1.2/16'::INET)

-- Test 150: query (line 757)
SELECT netmask('192.168.1.2/10'::INET)

-- Test 151: query (line 762)
SELECT netmask('192.168.1.2/0'::INET)

-- Test 152: query (line 767)
SELECT netmask('2001:4f8:3:ba::/64'::INET)

-- Test 153: query (line 772)
SELECT netmask('2001:4f8:3:ba::/0'::INET)

-- Test 154: query (line 777)
SELECT netmask('2001:4f8:3:ba:2e0:81ff:fe22:d1f1/128'::INET)

-- Test 155: query (line 782)
SELECT netmask('::ffff:1.2.3.1/120'::INET)

-- Test 156: query (line 787)
SELECT netmask('::ffff:1.2.3.1/20'::INET)

-- Test 157: query (line 794)
SELECT set_masklen('10.1.0.0/16'::INET, 10)

-- Test 158: query (line 799)
SELECT set_masklen('192.168.0.1/16'::INET, 32)

-- Test 159: statement (line 804)
SELECT set_masklen('192.168.0.1'::INET, 100)

-- Test 160: statement (line 807)
SELECT set_masklen('192.168.0.1'::INET, 33)

-- Test 161: statement (line 810)
SELECT set_masklen('192.168.0.1'::INET, -1)

-- Test 162: query (line 813)
SELECT set_masklen('192.168.0.1'::INET, 0)

-- Test 163: query (line 818)
SELECT set_masklen('::ffff:192.168.0.1'::INET, 100)

-- Test 164: statement (line 823)
SELECT set_masklen('::ffff:192.168.0.1'::INET, -1)

-- Test 165: statement (line 826)
SELECT set_masklen('::ffff:192.168.0.1'::INET, 129)

-- Test 166: query (line 829)
SELECT set_masklen('::ffff:192.168.0.1/24'::INET, 0)

-- Test 167: query (line 839)
SELECT text('10.1.0.0/16'::INET)

-- Test 168: query (line 844)
SELECT '192.168.0.1'::INET::TEXT

-- Test 169: query (line 849)
SELECT text('192.168.0.1/16'::INET)

-- Test 170: query (line 854)
SELECT '192.168.0.1/16'::INET::TEXT

-- Test 171: query (line 859)
SELECT text('192.168.0.1'::INET)

-- Test 172: query (line 864)
SELECT text('192.168.0.1/32'::INET)

-- Test 173: query (line 869)
SELECT text('::ffff:192.168.0.1'::INET)

-- Test 174: query (line 874)
SELECT text('::ffff:192.168.0.1/24'::INET)

-- Test 175: query (line 881)
SELECT text('::ffff:192.168.0.1/24'::INET)

-- Test 176: query (line 887)
SELECT host(max('192.168.0.2/24'::INET)) FROM (VALUES (1)) AS t(x)

-- Test 177: query (line 896)
SELECT '127.001.002.003'::INET, '127.001.002.003/016'::INET, '010.001.002.003'::INET

-- Test 178: query (line 905)
SELECT inet('some_invalid_value')

query T
SELECT inet('::111')

-- Test 179: query (line 913)
SELECT inet('192.168.0.2')

-- Test 180: query (line 918)
SELECT inet('::ffff:192.168.0.1/24')

