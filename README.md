
fasterjson_test
===============

A test for RapidJson(C++) and fasterjson(C).

Test Result:
=============

(Ubuntu 14.04 LTS, Intel 8200 2.4GHz / 4 Core / 4GB RAM)

    guozi@77Studio:~/fasterjson_test$ time -p ./fasterjson_press ../../data/test_big.json 10000

    Elapse time is 132.976 ms
    real 0.13
    user 0.13
    sys 0.00
    
    guozi@77Studio:~/fasterjson_test$ time -p ./fasterjson_press ../../data/test_big2.json 10000

    Elapse time is 4256.953 ms
    real 4.25
    user 4.25
    sys 0.00
    
    guozi@77Studio:~/fasterjson_test$ time -p ./rapidjson_test ../../data/test_big.json 10000

    Elapse time is 70.554 ms
    real 0.07
    user 0.07
    sys 0.00
    
    guozi@77Studio:~/fasterjson_test$ time -p ./rapidjson_test ../../data/test_big2.json 10000

    Elapse time is 2565.334 ms
    real 2.56
    user 2.49
    sys 0.07

    guozi@77Studio:~/fasterjson_test$ 

Complie
========

You can complie it in Visual Studio 2013 and CodeBlocks(Windows or Linux),

or use "make" command to complie it in console (Linux or Windows cygwin or MinGW).

Like this:

    guozi@77Studio:~/fasterjson_test$ make

Blog
=====

[http://www.cnblogs.com/shines77/](http://www.cnblogs.com/shines77/)
