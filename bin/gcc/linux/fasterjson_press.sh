#!/bin/bash
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
