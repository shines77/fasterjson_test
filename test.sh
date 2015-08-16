#!/bin/bash
echo ""
echo ""
echo "fasterjson_press data/test_big.json 10000"
time -p ./bin/gcc/linux/fasterjson_press ./bin/data/test_big.json 10000
echo ""
echo ""
echo "fasterjson_press data/test_big2.json 10000"
time -p ./bin/gcc/linux/fasterjson_press ./bin/data/test_big2.json 10000
echo ""
echo ""

echo "rapidjson_test data/test_big.json 10000"
time -p ./bin/gcc/linux/rapidjson_test ./bin/data/test_big.json 10000
echo ""
echo ""
echo "rapidjson_test data/test_big2.json 10000"
time -p ./bin/gcc/linux/rapidjson_test ./bin/data/test_big2.json 10000
echo ""
echo ""
