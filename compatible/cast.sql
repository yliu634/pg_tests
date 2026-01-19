-- PostgreSQL compatible tests from cast
-- 352 tests

-- Test 1: statement (line 23)
INSERT INTO assn_cast(c) VALUES ('a')

-- Test 2: statement (line 26)
INSERT INTO assn_cast(c) VALUES (null), ('b')

-- Test 3: statement (line 29)
INSERT INTO assn_cast(c) VALUES ('abc')

-- Test 4: query (line 32)
INSERT INTO assn_cast(c) VALUES (1) RETURNING c

-- Test 5: statement (line 37)
INSERT INTO assn_cast(c) VALUES (123)

-- Test 6: statement (line 40)
PREPARE insert_c AS INSERT INTO assn_cast(c) VALUES ($1)

-- Test 7: statement (line 43)
EXECUTE insert_c('foo')

-- Test 8: statement (line 49)
DELETE FROM assn_cast

-- Test 9: statement (line 52)
EXECUTE insert_c(' ')

-- Test 10: query (line 58)
SELECT concat('"', c, '"') FROM assn_cast

-- Test 11: statement (line 64)
INSERT INTO assn_cast(vc) VALUES ('a')

-- Test 12: statement (line 67)
INSERT INTO assn_cast(vc) VALUES (null), ('b')

-- Test 13: statement (line 70)
INSERT INTO assn_cast(vc) VALUES ('abc')

-- Test 14: query (line 73)
INSERT INTO assn_cast(vc) VALUES (1) RETURNING vc

-- Test 15: statement (line 78)
INSERT INTO assn_cast(vc) VALUES (123)

-- Test 16: statement (line 81)
INSERT INTO assn_cast(qc) VALUES ('a')

-- Test 17: statement (line 84)
INSERT INTO assn_cast(qc) VALUES (null), ('b')

-- Test 18: query (line 87)
INSERT INTO assn_cast(qc) VALUES ('abc') RETURNING qc

-- Test 19: query (line 95)
INSERT INTO assn_cast(qc) VALUES (123) RETURNING qc

-- Test 20: statement (line 102)
INSERT INTO assn_cast(qc) VALUES (1234)

-- Test 21: statement (line 105)
PREPARE insert_qc AS INSERT INTO assn_cast(qc) VALUES ($1)

-- Test 22: statement (line 108)
DELETE FROM assn_cast

-- Test 23: statement (line 111)
EXECUTE insert_qc('foo')

-- Test 24: query (line 117)
SELECT qc FROM assn_cast

-- Test 25: statement (line 123)
INSERT into assn_cast(b) VALUES ('1')

-- Test 26: statement (line 126)
INSERT INTO assn_cast(b) VALUES (null), ('1')

-- Test 27: statement (line 131)
INSERT into assn_cast(b) VALUES ('01')

-- Test 28: statement (line 134)
INSERT into assn_cast(b) VALUES (1)

-- Test 29: statement (line 137)
INSERT INTO assn_cast(i) VALUES ('1')

-- Test 30: statement (line 140)
INSERT INTO assn_cast(i) VALUES (null), ('1')

-- Test 31: statement (line 143)
PREPARE insert_i AS INSERT INTO assn_cast(i) VALUES ($1)

-- Test 32: statement (line 146)
EXECUTE insert_i('1')

-- Test 33: statement (line 152)
INSERT INTO assn_cast(i2) VALUES (999999999)

-- Test 34: statement (line 155)
PREPARE insert_i2 AS INSERT INTO assn_cast(i2) VALUES ($1)

-- Test 35: statement (line 158)
EXECUTE insert_i2(99999999)

-- Test 36: statement (line 161)
INSERT INTO assn_cast(f4) VALUES (18754999.99)

-- Test 37: statement (line 164)
PREPARE insert_f4 AS INSERT INTO assn_cast(f4) VALUES ($1)

-- Test 38: statement (line 167)
EXECUTE insert_f4(18754999.99)

-- Test 39: query (line 170)
SELECT f4 FROM assn_cast WHERE f4 IS NOT NULL

-- Test 40: statement (line 176)
INSERT INTO assn_cast(t) VALUES ('1970-01-01'::timestamptz)

-- Test 41: statement (line 179)
INSERT INTO assn_cast(d) VALUES (11.22), (88.99)

-- Test 42: statement (line 182)
INSERT INTO assn_cast(d) VALUES (22.33::DECIMAL(10, 0)), (99.11::DECIMAL(10, 2))

-- Test 43: statement (line 185)
INSERT INTO assn_cast(d) VALUES (33.11::DECIMAL(10, 0)), (44.44::DECIMAL(10, 0))

-- Test 44: statement (line 188)
PREPARE insert_d AS INSERT INTO assn_cast(d) VALUES ($1)

-- Test 45: statement (line 191)
EXECUTE insert_d(123.45)

-- Test 46: statement (line 194)
PREPARE insert_d2 AS INSERT INTO assn_cast(d) SELECT * FROM (VALUES ($1::DECIMAL(10, 2)))

-- Test 47: statement (line 197)
EXECUTE insert_d2(67.89)

-- Test 48: query (line 200)
SELECT d FROM assn_cast WHERE d IS NOT NULL

-- Test 49: statement (line 212)
INSERT INTO assn_cast(a) VALUES (ARRAY[])

-- Test 50: statement (line 215)
INSERT INTO assn_cast(a) VALUES (ARRAY[NULL])

-- Test 51: statement (line 218)
INSERT INTO assn_cast(a) VALUES (ARRAY[1.1])

-- Test 52: statement (line 221)
INSERT INTO assn_cast(a) VALUES (ARRAY[2.88, NULL, 15])

-- Test 53: statement (line 224)
INSERT INTO assn_cast(a) VALUES (ARRAY[3.99, NULL, 16]::DECIMAL(10, 2)[])

-- Test 54: statement (line 227)
INSERT INTO assn_cast(a) VALUES (ARRAY[5.55, 6.66::DECIMAL(10, 2)])

-- Test 55: statement (line 230)
PREPARE insert_a AS INSERT INTO assn_cast(a) VALUES ($1)

-- Test 56: statement (line 233)
EXECUTE insert_a(ARRAY[7.77, 8.88::DECIMAL(10, 2)])

-- Test 57: statement (line 236)
PREPARE insert_a2 AS INSERT INTO assn_cast(a) VALUES (ARRAY[$1])

-- Test 58: statement (line 239)
EXECUTE insert_a2(20.2)

-- Test 59: statement (line 242)
PREPARE insert_a3 AS INSERT INTO assn_cast(a) VALUES (ARRAY[30.12, $1, 32.1])

-- Test 60: statement (line 245)
EXECUTE insert_a3(30.9)

-- Test 61: query (line 248)
SELECT a FROM assn_cast WHERE a IS NOT NULL

-- Test 62: statement (line 261)
INSERT INTO assn_cast(s) VALUES (1)

-- Test 63: statement (line 264)
PREPARE insert_s AS INSERT INTO assn_cast(s) VALUES ($1)

-- Test 64: statement (line 267)
EXECUTE insert_s(2)

-- Test 65: query (line 270)
SELECT s FROM assn_cast WHERE s IS NOT NULL

-- Test 66: statement (line 276)
INSERT INTO assn_cast(ca) VALUES (ARRAY['foo', 'a'])

-- Test 67: statement (line 279)
PREPARE insert_ca AS INSERT INTO assn_cast(ca) VALUES ($1)

-- Test 68: statement (line 282)
EXECUTE insert_ca(ARRAY['a', 'foo'])

-- Test 69: statement (line 285)
INSERT INTO assn_cast(vba) VALUES (ARRAY[B'11', B'1'])

-- Test 70: statement (line 288)
PREPARE insert_vba AS INSERT INTO assn_cast(vba) VALUES ($1)

-- Test 71: statement (line 291)
EXECUTE insert_vba(ARRAY[B'1', B'11'])

-- Test 72: statement (line 297)
CREATE TABLE assn_cast_int_default (
  k INT,
  -- TODO(mgartner): This should not cause the CREATE TABLE statement to fail.
  -- See #74090.
  -- i1 INT2 DEFAULT 9999999,
  i2 INT2 DEFAULT 9999999::INT
)

-- Test 73: statement (line 306)
INSERT INTO assn_cast_int_default(k) VALUES (1)

-- Test 74: statement (line 309)
CREATE TABLE assn_cast_char_default (
  c CHAR DEFAULT 'foo'::TEXT,
  c2 CHAR(2) DEFAULT 'bar',
  qc "char" DEFAULT 'baz'
)

-- Test 75: statement (line 317)
INSERT INTO assn_cast_char_default(c2) VALUES ('ab')

-- Test 76: statement (line 321)
INSERT INTO assn_cast_char_default(c) VALUES ('a')

-- Test 77: statement (line 325)
INSERT INTO assn_cast_char_default(c, c2) VALUES ('a', 'ab')

-- Test 78: query (line 328)
SELECT * FROM assn_cast_char_default

-- Test 79: statement (line 333)
CREATE TABLE assn_cast_dec_default (
  k INT,
  d DECIMAL(10, 0) DEFAULT 1.56::DECIMAL(10, 2),
  d1 DECIMAL(10, 1) DEFAULT 1.58
)

-- Test 80: statement (line 340)
INSERT INTO assn_cast_dec_default(k) VALUES (1)

-- Test 81: query (line 343)
SELECT * FROM assn_cast_dec_default

-- Test 82: statement (line 352)
DELETE FROM assn_cast

-- Test 83: statement (line 355)
INSERT INTO assn_cast (c) VALUES (NULL)

-- Test 84: statement (line 358)
UPDATE assn_cast SET c = 'abc'

-- Test 85: query (line 361)
UPDATE assn_cast SET c = 1 RETURNING c

-- Test 86: statement (line 366)
UPDATE assn_cast SET c = 123

-- Test 87: statement (line 369)
UPDATE assn_cast SET c = NULL

-- Test 88: statement (line 372)
PREPARE update_c AS UPDATE assn_cast SET c = $1

-- Test 89: statement (line 375)
EXECUTE update_c('foo')

-- Test 90: statement (line 381)
EXECUTE update_c(' ')

-- Test 91: query (line 384)
SELECT concat('"', c, '"') FROM assn_cast

-- Test 92: query (line 392)
SELECT concat('"', c, '"') FROM assn_cast

-- Test 93: statement (line 397)
UPDATE assn_cast SET qc = 'a'

-- Test 94: query (line 400)
UPDATE assn_cast SET qc = 'abc' RETURNING qc

-- Test 95: statement (line 407)
UPDATE assn_cast SET qc = 1234

-- Test 96: statement (line 410)
PREPARE update_qc AS UPDATE assn_cast SET qc = $1

-- Test 97: statement (line 413)
EXECUTE update_qc('foo')

-- Test 98: query (line 416)
SELECT qc FROM assn_cast

-- Test 99: query (line 424)
SELECT qc FROM assn_cast

-- Test 100: statement (line 429)
UPDATE assn_cast SET i = '1'

-- Test 101: statement (line 432)
PREPARE update_i AS UPDATE assn_cast SET i = $1

-- Test 102: statement (line 435)
EXECUTE update_i('1')

-- Test 103: statement (line 441)
UPDATE assn_cast SET i2 = 999999999

-- Test 104: statement (line 444)
PREPARE update_i2 AS UPDATE assn_cast SET i2 = $1

-- Test 105: statement (line 447)
EXECUTE update_i2(99999999)

-- Test 106: query (line 450)
UPDATE assn_cast SET d = 11.22 RETURNING d

-- Test 107: query (line 455)
UPDATE assn_cast SET d = 11.22::DECIMAL(10, 0) RETURNING d

-- Test 108: query (line 460)
UPDATE assn_cast SET d = 11.22::DECIMAL(10, 2) RETURNING d

-- Test 109: statement (line 465)
PREPARE update_d AS UPDATE assn_cast SET d = $1

-- Test 110: statement (line 468)
EXECUTE update_d(123.45)

-- Test 111: query (line 471)
SELECT d FROM assn_cast

-- Test 112: statement (line 476)
PREPARE update_d2 AS UPDATE assn_cast SET d = (SELECT * FROM (VALUES ($1::DECIMAL(10, 2))))

-- Test 113: statement (line 479)
EXECUTE update_d2(67.89)

-- Test 114: query (line 482)
SELECT d FROM assn_cast

-- Test 115: query (line 487)
UPDATE assn_cast SET a = ARRAY[] RETURNING a

-- Test 116: query (line 492)
UPDATE assn_cast SET a = ARRAY[NULL] RETURNING a

-- Test 117: query (line 497)
UPDATE assn_cast SET a = ARRAY[1.1] RETURNING a

-- Test 118: query (line 502)
UPDATE assn_cast SET a = ARRAY[2.88, NULL, 15] RETURNING a

-- Test 119: query (line 507)
UPDATE assn_cast SET a = ARRAY[3.99, NULL, 16]::DECIMAL(10, 2)[] RETURNING a

-- Test 120: query (line 512)
UPDATE assn_cast SET a = ARRAY[5.55, 6.66::DECIMAL(10, 2)] RETURNING a

-- Test 121: statement (line 517)
PREPARE update_a AS UPDATE assn_cast SET a = $1

-- Test 122: statement (line 520)
EXECUTE update_a(ARRAY[7.77, 8.88::DECIMAL(10, 2)])

-- Test 123: query (line 523)
SELECT a FROM assn_cast

-- Test 124: statement (line 528)
PREPARE update_a2 AS UPDATE assn_cast SET a = ARRAY[$1]

-- Test 125: statement (line 531)
EXECUTE update_a2(20.2)

-- Test 126: query (line 534)
SELECT a FROM assn_cast

-- Test 127: statement (line 539)
PREPARE update_a3 AS UPDATE assn_cast SET a = ARRAY[30.12, $1, 32.1]

-- Test 128: statement (line 542)
EXECUTE update_a3(30.9)

-- Test 129: query (line 545)
SELECT a FROM assn_cast

-- Test 130: statement (line 550)
UPDATE assn_cast SET t = (SELECT (10, 11))

-- Test 131: statement (line 553)
UPDATE assn_cast SET t = 3.2

-- Test 132: statement (line 556)
UPDATE assn_cast SET (i, t) = (1, 3.2)

-- Test 133: statement (line 563)
CREATE TABLE assn_cast_upsert (
  k INT PRIMARY KEY,
  c CHAR,
  qc "char",
  i2 INT2,
  d DECIMAL(10, 0),
  a DECIMAL(10, 0)[]
)

-- Test 134: statement (line 573)
UPSERT INTO assn_cast_upsert (k, c) VALUES (1, 'abc')

-- Test 135: statement (line 576)
UPSERT INTO assn_cast_upsert (k, c) VALUES (1, 'a')

-- Test 136: statement (line 579)
UPSERT INTO assn_cast_upsert (k, c) VALUES (1, 'def')

-- Test 137: statement (line 582)
UPSERT INTO assn_cast_upsert (k, c) VALUES ('1', 'def')

-- Test 138: statement (line 585)
UPSERT INTO assn_cast_upsert (k, c) VALUES (1, 123)

-- Test 139: statement (line 591)
UPSERT INTO assn_cast_upsert (k, c) VALUES (1, 'b')

-- Test 140: statement (line 594)
UPSERT INTO assn_cast_upsert (k, c) VALUES ('1', 'c')

-- Test 141: statement (line 597)
UPSERT INTO assn_cast_upsert (k, c) VALUES (1, NULL)

-- Test 142: statement (line 600)
PREPARE upsert_c AS UPSERT INTO assn_cast_upsert (k, c) VALUES ($1, $2)

-- Test 143: statement (line 603)
EXECUTE upsert_c(1, 'foo')

-- Test 144: statement (line 606)
EXECUTE upsert_c(2, 'foo')

-- Test 145: statement (line 612)
EXECUTE upsert_c(1, ' ')

-- Test 146: statement (line 615)
EXECUTE upsert_c(2, ' ')

-- Test 147: query (line 618)
SELECT k, concat('"', c, '"') FROM assn_cast_upsert

-- Test 148: query (line 630)
SELECT k, concat('"', c, '"') FROM assn_cast_upsert

-- Test 149: statement (line 637)
DELETE FROM assn_cast_upsert

-- Test 150: statement (line 640)
UPSERT INTO assn_cast_upsert (k, qc) VALUES (1, 'a')

-- Test 151: query (line 643)
UPSERT INTO assn_cast_upsert (k, qc) VALUES (1, 'abc') RETURNING qc

-- Test 152: statement (line 650)
UPSERT INTO assn_cast_upsert (k, qc) VALUES (1, 1234)

-- Test 153: statement (line 653)
PREPARE upsert_qc AS UPSERT INTO assn_cast_upsert (k, qc) VALUES ($1, $2)

-- Test 154: statement (line 656)
EXECUTE upsert_qc(1, 'foo')

-- Test 155: query (line 659)
SELECT qc FROM assn_cast_upsert

-- Test 156: query (line 667)
SELECT qc FROM assn_cast_upsert

-- Test 157: statement (line 672)
UPSERT INTO assn_cast_upsert (k, i2) VALUES (1, 999999999)

-- Test 158: statement (line 675)
PREPARE upsert_i2 AS UPSERT INTO assn_cast_upsert (k, i2) VALUES ($1, $2)

-- Test 159: statement (line 678)
EXECUTE upsert_i2(1, 99999999)

-- Test 160: query (line 681)
UPSERT INTO assn_cast_upsert (k, d) VALUES (1, 11.22) RETURNING d

-- Test 161: query (line 686)
UPSERT INTO assn_cast_upsert (k, d) VALUES (1, 11.22::DECIMAL(10, 0)) RETURNING d

-- Test 162: query (line 691)
UPSERT INTO assn_cast_upsert (k, d) VALUES (1, 11.22::DECIMAL(10, 2)) RETURNING d

-- Test 163: statement (line 696)
PREPARE upsert_d AS UPSERT INTO assn_cast_upsert (k, d) VALUES ($1, $2)

-- Test 164: statement (line 699)
EXECUTE upsert_d(1, 123.45)

-- Test 165: query (line 702)
SELECT d FROM assn_cast_upsert

-- Test 166: statement (line 707)
PREPARE upsert_d2 AS UPSERT INTO assn_cast_upsert (k, d) VALUES (1, (SELECT * FROM (VALUES ($1::DECIMAL(10, 2)))))

-- Test 167: statement (line 710)
EXECUTE upsert_d2(67.89)

-- Test 168: query (line 713)
SELECT d FROM assn_cast_upsert

-- Test 169: query (line 718)
UPSERT INTO assn_cast_upsert (k, a) VALUES (1, ARRAY[]) RETURNING a

-- Test 170: query (line 723)
UPSERT INTO assn_cast_upsert (k, a) VALUES (1, ARRAY[NULL]) RETURNING a

-- Test 171: query (line 728)
UPSERT INTO assn_cast_upsert (k, a) VALUES (1, ARRAY[1.1]) RETURNING a

-- Test 172: query (line 733)
UPSERT INTO assn_cast_upsert (k, a) VALUES (1, ARRAY[2.88, NULL, 15]) RETURNING a

-- Test 173: query (line 738)
UPSERT INTO assn_cast_upsert (k, a) VALUES (1, ARRAY[3.99, NULL, 16]::DECIMAL(10, 2)[]) RETURNING a

-- Test 174: query (line 743)
UPSERT INTO assn_cast_upsert (k, a) VALUES (1, ARRAY[5.55, 6.66::DECIMAL(10, 2)]) RETURNING a

-- Test 175: statement (line 748)
PREPARE upsert_a AS UPSERT INTO assn_cast_upsert (k, a) VALUES ($1, $2)

-- Test 176: statement (line 751)
EXECUTE upsert_a(1, ARRAY[7.77, 8.88::DECIMAL(10, 2)])

-- Test 177: query (line 754)
SELECT a FROM assn_cast_upsert

-- Test 178: statement (line 759)
PREPARE upsert_a2 AS UPSERT INTO assn_cast_upsert (k, a) VALUES ($1, ARRAY[$2])

-- Test 179: statement (line 762)
EXECUTE upsert_a2(1, 20.2)

-- Test 180: query (line 765)
SELECT a FROM assn_cast_upsert

-- Test 181: statement (line 770)
PREPARE upsert_a3 AS UPSERT INTO assn_cast_upsert (k, a) VALUES ($1, ARRAY[30.12, $2, 32.1])

-- Test 182: statement (line 773)
EXECUTE upsert_a3(1, 30.9)

-- Test 183: query (line 776)
SELECT a FROM assn_cast_upsert

-- Test 184: statement (line 785)
CREATE TABLE assn_cast_do_nothing (
  k INT PRIMARY KEY,
  d DECIMAL(10, 0) UNIQUE,
  c CHAR UNIQUE
)

-- Test 185: statement (line 792)
INSERT INTO assn_cast_do_nothing VALUES (1, 2.34, 'abc') ON CONFLICT DO NOTHING

-- Test 186: statement (line 795)
INSERT INTO assn_cast_do_nothing VALUES (1, 2.34, 'a') ON CONFLICT DO NOTHING

-- Test 187: statement (line 799)
INSERT INTO assn_cast_do_nothing VALUES (1, 5.67, 'b') ON CONFLICT DO NOTHING

-- Test 188: statement (line 803)
INSERT INTO assn_cast_do_nothing VALUES (2, 2.34, 'b') ON CONFLICT DO NOTHING

-- Test 189: statement (line 807)
INSERT INTO assn_cast_do_nothing VALUES (2, 5.67, 'a') ON CONFLICT DO NOTHING

-- Test 190: statement (line 810)
INSERT INTO assn_cast_do_nothing VALUES ('1', 2.34, 'a') ON CONFLICT (k) DO NOTHING

-- Test 191: statement (line 813)
INSERT INTO assn_cast_do_nothing VALUES (1, 2.45, 'a') ON CONFLICT (d) DO NOTHING

-- Test 192: statement (line 816)
INSERT INTO assn_cast_do_nothing VALUES (1, 2.45::DECIMAL(10, 2), 'a') ON CONFLICT (d) DO NOTHING

-- Test 193: statement (line 819)
INSERT INTO assn_cast_do_nothing VALUES (1, 2.0, 'a') ON CONFLICT (d) DO NOTHING

-- Test 194: statement (line 822)
INSERT INTO assn_cast_do_nothing VALUES (1, 2, 'a') ON CONFLICT (d) DO NOTHING

-- Test 195: query (line 825)
SELECT * FROM assn_cast_do_nothing

-- Test 196: statement (line 830)
PREPARE insert_do_nothing_d AS INSERT INTO assn_cast_do_nothing VALUES ($1, $2, $3) ON CONFLICT (d) DO NOTHING

-- Test 197: statement (line 833)
EXECUTE insert_do_nothing_d(1, 2.45, 'a')

-- Test 198: statement (line 836)
EXECUTE insert_do_nothing_d(1, 2.45::DECIMAL(10, 2), 'a')

-- Test 199: statement (line 839)
EXECUTE insert_do_nothing_d(1, 2.0, 'a')

-- Test 200: statement (line 842)
EXECUTE insert_do_nothing_d(1, 2, 'a')

-- Test 201: statement (line 845)
EXECUTE insert_do_nothing_d(1, 2.56, 'a')

-- Test 202: query (line 848)
SELECT * FROM assn_cast_do_nothing

-- Test 203: statement (line 853)
PREPARE insert_do_nothing_d2 AS INSERT INTO assn_cast_do_nothing VALUES ($1, $2::DECIMAL(10, 0), $3) ON CONFLICT (d) DO NOTHING

-- Test 204: statement (line 856)
EXECUTE insert_do_nothing_d2(1, 2.45, 'a')

-- Test 205: statement (line 859)
EXECUTE insert_do_nothing_d2(1, 2.45::DECIMAL(10, 2), 'a')

-- Test 206: statement (line 862)
EXECUTE insert_do_nothing_d2(1, 2.0, 'a')

-- Test 207: statement (line 865)
EXECUTE insert_do_nothing_d2(1, 2, 'a')

-- Test 208: statement (line 868)
EXECUTE insert_do_nothing_d2(1, 2.56, 'a')

-- Test 209: query (line 871)
SELECT * FROM assn_cast_do_nothing

-- Test 210: statement (line 880)
CREATE TABLE assn_cast_do_update (
  k INT PRIMARY KEY,
  d DECIMAL(10, 0) UNIQUE,
  c CHAR UNIQUE
)

-- Test 211: statement (line 887)
INSERT INTO assn_cast_do_update VALUES (1, 2.34, 'abc') ON CONFLICT (c) DO UPDATE SET c = 'b'

-- Test 212: statement (line 890)
INSERT INTO assn_cast_do_update VALUES (1, 2.34, 'a') ON CONFLICT (c) DO UPDATE SET c = 'b'

-- Test 213: statement (line 893)
INSERT INTO assn_cast_do_update VALUES (1, 2.34, 'a') ON CONFLICT (c) DO UPDATE SET c = 'abc'

-- Test 214: statement (line 896)
INSERT INTO assn_cast_do_update VALUES (1, 2.34, 'a') ON CONFLICT (c) DO UPDATE SET c = 'b'

-- Test 215: query (line 899)
SELECT * FROM assn_cast_do_update

-- Test 216: statement (line 904)
PREPARE insert_do_update_c AS
INSERT INTO assn_cast_do_update VALUES (1, 2.34, $1) ON CONFLICT (c) DO UPDATE SET c = $2

-- Test 217: statement (line 908)
EXECUTE insert_do_update_c('b', 'abc')

-- Test 218: statement (line 914)
EXECUTE insert_do_update_c('c', 'abc')

-- Test 219: statement (line 917)
EXECUTE insert_do_update_c('b', 'c')

-- Test 220: query (line 920)
SELECT * FROM assn_cast_do_update

-- Test 221: query (line 925)
INSERT INTO assn_cast_do_update VALUES ('1', 2.34, 'a')
ON CONFLICT (k) DO UPDATE SET k = '2'
RETURNING k

-- Test 222: query (line 932)
INSERT INTO assn_cast_do_update VALUES (1, 2.45, 'a')
ON CONFLICT (d) DO UPDATE SET d = 3.56
RETURNING d

-- Test 223: query (line 939)
INSERT INTO assn_cast_do_update VALUES (1, 3.56, 'a')
ON CONFLICT (d) DO UPDATE SET d = 5.12::DECIMAL(10, 2)
RETURNING d

-- Test 224: query (line 946)
SELECT * FROM assn_cast_do_update

-- Test 225: statement (line 951)
INSERT INTO assn_cast_do_update VALUES (3, 1.23, 'b')

-- Test 226: statement (line 954)
INSERT INTO assn_cast_do_update VALUES (3, 10.12, 'b')
ON CONFLICT (c) DO UPDATE SET c = 'c'

-- Test 227: statement (line 958)
INSERT INTO assn_cast_do_update VALUES (3, 10.12, 'b')
ON CONFLICT (c) DO UPDATE SET d = 5.45

-- Test 228: statement (line 962)
INSERT INTO assn_cast_do_update VALUES (3, 10.12, 'b')
ON CONFLICT (c) DO UPDATE SET d = 5.45::DECIMAL(10, 2)

-- Test 229: statement (line 970)
CREATE TABLE assn_cast_p (p DECIMAL(10, 2) PRIMARY KEY, d DECIMAL(10, 2) UNIQUE);
INSERT INTO assn_cast_p VALUES (1.0, 10.0);

-- Test 230: statement (line 975)
CREATE TABLE assn_cast_c (c INT PRIMARY KEY, p DECIMAL(10, 0) REFERENCES assn_cast_p(p) ON UPDATE CASCADE);

-- Test 231: statement (line 978)
INSERT INTO assn_cast_c VALUES (1, 1.0);

-- Test 232: statement (line 981)
UPDATE assn_cast_p SET p = 1.2

-- Test 233: statement (line 984)
UPDATE assn_cast_p SET p = 2.0

-- Test 234: query (line 987)
SELECT * FROM assn_cast_c

-- Test 235: statement (line 992)
DROP TABLE assn_cast_c;

-- Test 236: statement (line 995)
CREATE TABLE assn_cast_c (c INT PRIMARY KEY, d DECIMAL(10, 0) REFERENCES assn_cast_p(d) ON UPDATE CASCADE);

-- Test 237: statement (line 998)
UPSERT INTO assn_cast_c VALUES (2, 10)

-- Test 238: statement (line 1001)
UPSERT INTO assn_cast_p VALUES (2.0, 11.22)

-- Test 239: statement (line 1004)
UPSERT INTO assn_cast_p VALUES (2.0, 11.00)

-- Test 240: statement (line 1007)
INSERT INTO assn_cast_p VALUES (2.0, 11.00) ON CONFLICT (d) DO UPDATE SET d = 12.99

-- Test 241: statement (line 1010)
INSERT INTO assn_cast_p VALUES (2.0, 11.00) ON CONFLICT (d) DO UPDATE SET d = 12.0

-- Test 242: statement (line 1014)
DROP TABLE assn_cast_c;

-- Test 243: statement (line 1017)
CREATE TABLE assn_cast_c (c INT PRIMARY KEY, p DECIMAL(10, 0) DEFAULT 3.1 REFERENCES assn_cast_p(p) ON UPDATE SET DEFAULT);

-- Test 244: statement (line 1020)
INSERT INTO assn_cast_c VALUES (2, 2.0);

-- Test 245: statement (line 1023)
UPDATE assn_cast_p SET p = 1.2

-- Test 246: statement (line 1026)
UPDATE assn_cast_p SET p = 3.0

-- Test 247: query (line 1029)
SELECT * FROM assn_cast_c

-- Test 248: statement (line 1034)
DROP TABLE assn_cast_c;

-- Test 249: statement (line 1037)
CREATE TABLE assn_cast_c (c INT PRIMARY KEY, d DECIMAL(10, 0) DEFAULT 3.1 REFERENCES assn_cast_p(d) ON UPDATE SET DEFAULT);

-- Test 250: statement (line 1040)
INSERT INTO assn_cast_c VALUES (2, 12)

-- Test 251: statement (line 1043)
UPSERT INTO assn_cast_p VALUES (3.0, 3.4)

-- Test 252: statement (line 1046)
UPSERT INTO assn_cast_p VALUES (3.0, 3.0)

-- Test 253: statement (line 1049)
INSERT INTO assn_cast_p VALUES (3.0, 1) ON CONFLICT (p) DO UPDATE SET d = 3.4

-- Test 254: statement (line 1052)
INSERT INTO assn_cast_p VALUES (4.0, 3.0) ON CONFLICT (d) DO UPDATE SET d = 3.4

-- Test 255: statement (line 1055)
INSERT INTO assn_cast_p VALUES (3.0, 1) ON CONFLICT (p) DO UPDATE SET d = 3.0

-- Test 256: statement (line 1058)
INSERT INTO assn_cast_p VALUES (4.0, 3.0) ON CONFLICT (d) DO UPDATE SET d = 3.0

-- Test 257: statement (line 1065)
CREATE TABLE assn_cast_comp (
  k INT PRIMARY KEY,
  i INT,
  i2 INT2 AS (i + 9999999) STORED,
  t TEXT,
  c CHAR AS (t) STORED,
  d DECIMAL(10, 0),
  d_comp DECIMAL(10, 2) AS (d) STORED,
  d2 DECIMAL(10, 2),
  d2_comp DECIMAL(10, 0) AS (d2) STORED
)

-- Test 258: statement (line 1078)
INSERT INTO assn_cast_comp(k, i) VALUES (1, 1)

-- Test 259: statement (line 1081)
INSERT INTO assn_cast_comp(k, t) VALUES (1, 'foo')

-- Test 260: statement (line 1084)
INSERT INTO assn_cast_comp(k, d, d2) VALUES (1, 1.56, 2.78)

-- Test 261: query (line 1087)
SELECT k, d, d_comp, d2, d2_comp FROM assn_cast_comp

-- Test 262: statement (line 1092)
UPDATE assn_cast_comp SET i = 1 WHERE k = 1

-- Test 263: statement (line 1095)
UPDATE assn_cast_comp SET t = 'foo' WHERE k = 1

-- Test 264: statement (line 1098)
UPDATE assn_cast_comp SET d = 3.45, d2 = 4.56 WHERE k = 1

-- Test 265: query (line 1101)
SELECT k, d, d_comp, d2, d2_comp FROM assn_cast_comp

-- Test 266: statement (line 1106)
UPSERT INTO assn_cast_comp (k, i) VALUES (1, 1)

-- Test 267: statement (line 1109)
UPSERT INTO assn_cast_comp (k, i) VALUES (2, 2)

-- Test 268: statement (line 1112)
UPSERT INTO assn_cast_comp (k, t) VALUES (1, 'foo')

-- Test 269: statement (line 1115)
UPSERT INTO assn_cast_comp (k, t) VALUES (2, 'bar')

-- Test 270: statement (line 1118)
UPSERT INTO assn_cast_comp (k, d, d2) VALUES (1, 5.43, 7.89)

-- Test 271: query (line 1121)
SELECT k, d, d_comp, d2, d2_comp FROM assn_cast_comp

-- Test 272: statement (line 1130)
CREATE TABLE assn_cast_on_update (
    k INT PRIMARY KEY,
    i INT UNIQUE,
    d DECIMAL(10, 1) ON UPDATE 1.23,
    d2 DECIMAL(10, 1) ON UPDATE 1.23::DECIMAL(10, 2),
    d_comp DECIMAL(10, 0) AS (d) STORED
)

-- Test 273: statement (line 1139)
INSERT INTO assn_cast_on_update (k, i) VALUES (1, 10)

-- Test 274: statement (line 1142)
UPDATE assn_cast_on_update SET i = 11 WHERE k = 1

-- Test 275: query (line 1145)
SELECT * FROM assn_cast_on_update

-- Test 276: statement (line 1150)
UPDATE assn_cast_on_update SET d = NULL, d2 = NULL  WHERE k = 1

-- Test 277: statement (line 1153)
UPSERT INTO assn_cast_on_update (k, i) VALUES (1, 10)

-- Test 278: statement (line 1156)
UPSERT INTO assn_cast_on_update (k, i) VALUES (2, 20)

-- Test 279: query (line 1159)
SELECT * FROM assn_cast_on_update

-- Test 280: statement (line 1165)
INSERT INTO assn_cast_on_update (k, i) VALUES (2, 20) ON CONFLICT (i) DO UPDATE SET i = 30

-- Test 281: query (line 1168)
SELECT * FROM assn_cast_on_update

-- Test 282: statement (line 1178)
CREATE TABLE t45837 AS SELECT 1.25::decimal AS d

-- Test 283: query (line 1182)
SELECT d::decimal(10,1) FROM t45837

-- Test 284: statement (line 1187)
CREATE TABLE t2 AS SELECT 18446744073709551616::FLOAT AS f

-- Test 285: statement (line 1190)
SELECT f::int FROM t2

-- Test 286: statement (line 1193)
SELECT 23414123414::int2

-- Test 287: statement (line 1198)
CREATE TABLE t0(c0 DECIMAL UNIQUE); INSERT INTO t0(c0) VALUES(0);

-- Test 288: statement (line 1201)
CREATE TABLE t1(c0 DECIMAL); INSERT INTO t1(c0) VALUES(0);

-- Test 289: query (line 1205)
SELECT t0.c0 FROM t0 WHERE t0.c0 BETWEEN t0.c0 AND INTERVAL '-1'::DECIMAL

-- Test 290: query (line 1209)
SELECT t1.c0 FROM t1 WHERE t1.c0 BETWEEN t1.c0 AND INTERVAL '-1'::DECIMAL

-- Test 291: statement (line 1214)
CREATE TABLE t64429 (_int8 INT8, _int4 INT4);

-- Test 292: statement (line 1217)
INSERT INTO t64429 VALUES (3000000000, 300000);

-- Test 293: statement (line 1220)
SELECT _int8::INT2 FROM t64429

-- Test 294: statement (line 1223)
SELECT _int8::INT4 FROM t64429

-- Test 295: statement (line 1226)
SELECT _int4::INT2 FROM t64429

-- Test 296: statement (line 1230)
DELETE FROM t64429 WHERE true;

-- Test 297: statement (line 1233)
INSERT INTO t64429 VALUES (-3000000000, -300000);

-- Test 298: statement (line 1236)
SELECT _int8::INT2 FROM t64429

-- Test 299: statement (line 1239)
SELECT _int8::INT4 FROM t64429

-- Test 300: statement (line 1242)
SELECT _int4::INT2 FROM t64429

-- Test 301: statement (line 1247)
CREATE TABLE t66067_a (
  a INT,
  c CHAR(26),
  INDEX (c, a)
);

-- Test 302: statement (line 1254)
CREATE TABLE t66067_b (
  a INT,
  v VARCHAR(40)
);

-- Test 303: statement (line 1260)
INSERT INTO t66067_a VALUES (1, 'foo');
INSERT INTO t66067_b VALUES (1, 'bar');

-- Test 304: query (line 1264)
SELECT * FROM t66067_b b
INNER LOOKUP JOIN t66067_a a ON b.a = a.a
WHERE b.v = 'bar' AND a.c = 'foo'

-- Test 305: query (line 1271)
SELECT i, i::"char"::bytea, length(i::"char")
FROM (VALUES (32), (97), (127), (0), (-1), (-127), (-128)) v(i);

-- Test 306: statement (line 1283)
SELECT 128::"char";

-- Test 307: statement (line 1286)
SELECT (-129)::"char";

-- Test 308: query (line 1289)
SELECT ' 1 '::int, ' 1.2 '::float, ' 2.3 '::decimal, ' true '::bool

-- Test 309: query (line 1294)
SELECT i, i::oid, i::oid::text,
  i::oid::regproc, i::oid::regprocedure, i::oid::regnamespace, i::oid::regclass, i::oid::regtype, i::oid::regrole
FROM (VALUES (0), (1)) v(i)

-- Test 310: query (line 1302)
SELECT i, i::regproc::oid, i::regprocedure::oid, i::regnamespace::oid, i::regtype::oid, i::regclass::oid, i::regrole::oid,
  i::regproc, i::regprocedure, i::regnamespace, i::regtype, i::regclass, i::regrole
FROM (VALUES ('-')) v(i)

-- Test 311: statement (line 1309)
SELECT i, i::oid FROM (VALUES ('-')) v(i)

-- Test 312: statement (line 1312)
SELECT '-'::oid

-- Test 313: query (line 1315)
SELECT '-'::regclass, '-'::regclass::oid,
  '-'::regproc, '-'::regproc::oid,
  '-'::regprocedure, '-'::regprocedure::oid,
  '-'::regnamespace, '-'::regnamespace::oid,
  '-'::regtype, '-'::regtype::oid,
  '-'::regrole, '-'::regrole::oid

-- Test 314: statement (line 1328)
PREPARE s73450_a AS SELECT $1::INT2

-- Test 315: statement (line 1331)
EXECUTE s73450_a(999999)

-- Test 316: statement (line 1334)
PREPARE s73450_b AS SELECT $1::CHAR

-- Test 317: query (line 1337)
EXECUTE s73450_b('foo')

-- Test 318: statement (line 1342)
CREATE TABLE t73450 (c CHAR);

-- Test 319: statement (line 1345)
INSERT INTO t73450 VALUES ('f')

-- Test 320: query (line 1348)
SELECT * FROM t73450 WHERE c = 'foo'::CHAR

-- Test 321: statement (line 1353)
PREPARE s73450_c AS SELECT * FROM t73450 WHERE c = $1::CHAR

-- Test 322: query (line 1356)
EXECUTE s73450_c('foo')

-- Test 323: statement (line 1365)
CREATE TABLE t59489 (
  d12_3 DECIMAL(12, 3),
  d4_2 DECIMAL(4, 2)
)

-- Test 324: query (line 1371)
INSERT INTO t59489 (d12_3) VALUES (6000) RETURNING d12_3

-- Test 325: query (line 1376)
INSERT INTO t59489 (d12_3) VALUES (6e3) RETURNING d12_3

-- Test 326: query (line 1381)
SELECT d12_3 FROM t59489

-- Test 327: statement (line 1387)
INSERT INTO t59489 (d4_2) VALUES (600)

-- Test 328: statement (line 1390)
INSERT INTO t59489 (d4_2) VALUES (6e2)

-- Test 329: statement (line 1398)
select CASE WHEN false THEN 1::REGCLASS ELSE 2::REGNAMESPACE END;
select CASE WHEN false THEN 1::REGCLASS ELSE 2::REGPROC END;
select CASE WHEN false THEN 1::REGCLASS ELSE 2::REGPROCEDURE END;
select CASE WHEN false THEN 1::REGCLASS ELSE 2::REGROLE END;
select CASE WHEN false THEN 1::REGCLASS ELSE 2::REGTYPE END;
select CASE WHEN false THEN 1::REGNAMESPACE ELSE 2::REGCLASS END;
select CASE WHEN false THEN 1::REGNAMESPACE ELSE 2::REGPROC END;
select CASE WHEN false THEN 1::REGNAMESPACE ELSE 2::REGPROCEDURE END;
select CASE WHEN false THEN 1::REGNAMESPACE ELSE 2::REGROLE END;
select CASE WHEN false THEN 1::REGNAMESPACE ELSE 2::REGTYPE END;
select CASE WHEN false THEN 1::REGPROC ELSE 2::REGCLASS END;
select CASE WHEN false THEN 1::REGPROC ELSE 2::REGNAMESPACE END;
select CASE WHEN false THEN 1::REGPROC ELSE 2::REGPROCEDURE END;
select CASE WHEN false THEN 1::REGPROC ELSE 2::REGROLE END;
select CASE WHEN false THEN 1::REGPROC ELSE 2::REGTYPE END;
select CASE WHEN false THEN 1::REGPROCEDURE ELSE 2::REGCLASS END;
select CASE WHEN false THEN 1::REGPROCEDURE ELSE 2::REGNAMESPACE END;
select CASE WHEN false THEN 1::REGPROCEDURE ELSE 2::REGPROC END;
select CASE WHEN false THEN 1::REGPROCEDURE ELSE 2::REGROLE END;
select CASE WHEN false THEN 1::REGPROCEDURE ELSE 2::REGTYPE END;
select CASE WHEN false THEN 1::REGROLE ELSE 2::REGCLASS END;
select CASE WHEN false THEN 1::REGROLE ELSE 2::REGNAMESPACE END;
select CASE WHEN false THEN 1::REGROLE ELSE 2::REGPROC END;
select CASE WHEN false THEN 1::REGROLE ELSE 2::REGPROCEDURE END;
select CASE WHEN false THEN 1::REGROLE ELSE 2::REGTYPE END;
select CASE WHEN false THEN 1::REGTYPE ELSE 2::REGCLASS END;
select CASE WHEN false THEN 1::REGTYPE ELSE 2::REGNAMESPACE END;
select CASE WHEN false THEN 1::REGTYPE ELSE 2::REGPROC END;
select CASE WHEN false THEN 1::REGTYPE ELSE 2::REGPROCEDURE END;
select CASE WHEN false THEN 1::REGTYPE ELSE 2::REGROLE END;

-- Test 330: query (line 1433)
SELECT (1/3.0)::float4::text, (-1/3.0)::float8::text

-- Test 331: statement (line 1438)
SET extra_float_digits = -15

-- Test 332: query (line 1442)
SELECT (-1/3.0)::float4::text, (1/3.0)::float8::text

-- Test 333: statement (line 1448)
CREATE TABLE def_assn_cast (
  id INT4,
  a INT4 DEFAULT 1.0::FLOAT4,
  b VARCHAR DEFAULT 'true'::BOOL,
  c NAME DEFAULT 'foo'::CHAR
)

-- Test 334: statement (line 1456)
CREATE TABLE upd_assn_cast (
  id INT4,
  a TEXT ON UPDATE 'POINT(2.0 2.0)'::GEOMETRY,
  b FLOAT8 ON UPDATE 6::INT4,
  c VARCHAR ON UPDATE '{ "customer": "John Doe"}'::JSONB
)

-- Test 335: statement (line 1465)
INSERT INTO def_assn_cast(id) VALUES (1)

-- Test 336: statement (line 1468)
INSERT INTO upd_assn_cast(id) VALUES (1)

-- Test 337: statement (line 1471)
UPDATE upd_assn_cast SET id = 2

-- Test 338: query (line 1474)
SELECT * from def_assn_cast

-- Test 339: query (line 1479)
SELECT * from upd_assn_cast

-- Test 340: statement (line 1485)
CREATE TABLE fail_assn_cast (
  a BOOL DEFAULT 'foo'
)

-- Test 341: statement (line 1490)
CREATE TABLE fail_assn_cast (
  a DATE DEFAULT 1.0::FLOAT4
)

-- Test 342: statement (line 1495)
CREATE TABLE fail_assn_cast (
  b JSONB DEFAULT 'null'::CHAR
)

-- Test 343: statement (line 1500)
CREATE TABLE fail_assn_cast (
  a INT4 ON UPDATE 1.0::BOOL
)

-- Test 344: statement (line 1505)
CREATE TABLE fail_assn_cast (
  a FLOAT4 ON UPDATE '01/02/03'::DATE
)

-- Test 345: statement (line 1510)
CREATE TABLE fail_assn_cast (
  a NUMERIC ON UPDATE '1-2'::INTERVAL
)

-- Test 346: statement (line 1517)
CREATE TABLE IF NOT EXISTS t98373 AS
        SELECT
                g::INT2 AS _int2,
                g::INT4 AS _int4,
                g::INT8 AS _int8,
                g::FLOAT8 AS _float8,
                '2001-01-01'::DATE + g AS _date,
                '2001-01-01'::TIMESTAMP + g * '1 day'::INTERVAL AS _timestamp
        FROM
                generate_series(1, 5) AS g;

-- Test 347: query (line 1529)
SELECT
        regproc(_int2::INT8)::REGPROC AS col865
FROM
        t98373@[0]

-- Test 348: statement (line 1543)
CREATE TABLE t112515 (f FLOAT);
INSERT INTO t112515 VALUES (-1.5), (-0.5), (0.5), (1.5), (2.5);

-- Test 349: query (line 1547)
SELECT f::INT FROM t112515

-- Test 350: statement (line 1556)
CREATE TABLE t128294 (r REGCLASS);

let $table_id
SELECT 't128294'::REGCLASS::OID;

-- Test 351: statement (line 1562)
INSERT INTO t128294 (r) VALUES ($table_id);

-- Test 352: query (line 1565)
SELECT (SELECT r FROM t128294) FROM t128294;

