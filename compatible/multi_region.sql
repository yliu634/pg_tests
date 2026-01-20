-- PostgreSQL compatible tests from multi_region
-- 2 tests

-- Test 1: statement (line 3)
CREATE DATABASE region_test_db PRIMARY REGION "ap-southeast-2" SURVIVE ZONE FAILURE;

-- Test 2: statement (line 6)
ALTER DATABASE test PRIMARY REGION "ap-southeast-2";

