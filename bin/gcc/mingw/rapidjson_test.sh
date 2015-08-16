#!/bin/bash
echo ""
time -p ./rapidjson_test ../../data/test_big.json 10000
echo ""
time -p ./rapidjson_test ../../data/test_big2.json 10000
echo ""
