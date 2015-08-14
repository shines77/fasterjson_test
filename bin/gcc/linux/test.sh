#!/bin/bash
echo ""
echo "fasterjson_press data/test_big.json 10000"
echo ""
time -p ./fasterjson_press ../../data/test_big.json 10000
echo ""
echo "fasterjson_press data/test_big2.json 10000"
echo ""
time -p ./fasterjson_press ../../data/test_big2.json 10000
echo ""

echo ""
echo "rapidjson_test data/test_big.json 10000"
echo ""
time -p ./rapidjson_test ../../data/test_big.json 10000
echo ""
echo "rapidjson_test data/test_big2.json 10000"
echo ""
time -p ./rapidjson_test ../../data/test_big2.json 10000
echo ""
