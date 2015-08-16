#!/bin/sh
echo ""
echo "rapidjson_test data/test_big.json 10000"
echo ""
time -p ./bin/gcc/linux/rapidjson_test ./bin/data/test_big.json 10000
echo ""
echo "rapidjson_test data/test_big2.json 10000"
echo ""
time -p ./bin/gcc/linux/rapidjson_test ./bin/data/test_big2.json 10000
echo ""
