#!/bin/bash

sudo time -p ./rapidjson_test ../../data/test_big.json 10000
sudo time -p ./rapidjson_test ../../data/test_big2.json 10000
