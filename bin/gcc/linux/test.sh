#!/bin/bash
# ./fasterjson_press ../../data/test_big.json 10000
# ./fasterjson_press ../../data/test_big2.json 10000
echo ""
echo ""
echo "fasterjson_press data/test_big.json 10000"
time -p ./fasterjson_press ../../data/test_big.json 10000
echo ""
echo ""
echo "fasterjson_press data/test_big2.json 10000"
time -p ./fasterjson_press ../../data/test_big2.json 10000
echo ""
echo ""

echo "rapidjson_test data/test_big.json 10000"
time -p ./rapidjson_test ../../data/test_big.json 10000
echo ""
echo ""
echo "rapidjson_test data/test_big2.json 10000"
time -p ./rapidjson_test ../../data/test_big2.json 10000
echo ""
echo ""
