#!/bin/bash
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
