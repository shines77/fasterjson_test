#!/bin/bash
# ./fasterjson_press ../../data/test_big.json 10000
# ./fasterjson_press ../../data/test_big2.json 10000

echo ""
time -p ./fasterjson_press ../../data/test_big.json 10000
echo ""
time -p ./fasterjson_press ../../data/test_big2.json 10000
echo ""

time -p ./rapidjson_test ../../data/test_big.json 10000
echo ""
time -p ./rapidjson_test ../../data/test_big2.json 10000
echo ""
