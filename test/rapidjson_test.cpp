
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <time.h>

#include <cstdio>
#include <cstdlib>
#include <iostream>

#include "rapidjson/rapidjson.h"
#include "rapidjson/document.h"
#include "rapidjson/error/error.h"
#include "rapidjson/prettywriter.h"
#include "rapidjson/filestream.h"

#include "jimic/jmc_time.h"

//using namespace std;
//using namespace rapidjson;

static long _GetFileSize(char *filename)
{
    struct stat stat_buf;
    int ret;

    ret = stat(filename, &stat_buf);

    if (ret == -1)
        return -1;

    return stat_buf.st_size;
}

static int ReadEntireFile( char *filename , char *mode , char *buf , long *bufsize )
{
    FILE    *fp = NULL ;
    long    filesize ;
    long    lret ;

    if( filename == NULL )
        return -1;
    if( ! strcmp( filename , "" ) )
        return -1;

    filesize = _GetFileSize( filename ) ;
    if( filesize  < 0 )
        return -2;

    fp = fopen( filename , mode ) ;
    if( fp == NULL )
        return -3;

    if( filesize <= (*bufsize) )
    {
        lret = fread( buf , sizeof(char) , filesize , fp ) ;
        if( lret < filesize )
        {
            fclose( fp );
            return -4;
        }

        (*bufsize) = filesize ;

        fclose( fp );

        return 0;
    }
    else
    {
        lret = fread( buf , sizeof(char) , (*bufsize) , fp ) ;
        if( lret < (*bufsize) )
        {
            fclose( fp );
            return -4;
        }

        fclose( fp );

        return 1;
    }
}

static int ReadEntireFileSafely( char *filename , char *mode , char **pbuf , long *pbufsize )
{
    long    filesize ;

    int nret ;

    filesize = _GetFileSize( filename );

    (*pbuf) = (char*)malloc( filesize + 1 ) ;
    if( (*pbuf) == NULL )
        return -1;
    memset( (*pbuf) , 0x00 , filesize + 1 );

    nret = ReadEntireFile( filename , mode , (*pbuf) , & filesize ) ;
    if( nret )
    {
        free( (*pbuf) );
        (*pbuf) = NULL ;
        return nret;
    }
    else
    {
        if( pbufsize )
            (*pbufsize) = filesize ;
        return 0;
    }
}

int test_main(int argc, char *argv[])
{
    jmc_timestamp_t starttime;
    jmc_timefloat_t elapsedtime;

    starttime = jmc_get_timestamp();
    std::cout << "Hello world!" << std::endl;
    elapsedtime = jmc_get_elapsedtime_msf(starttime);

    printf("Elapse time is %0.3f ms\n", elapsedtime);
    return 0;
}

int main(int argc, char *argv[])
{
    char *json_buffer = NULL;
    int json_len;

    if (argc == 3) {
        char *json_buffer_bak = NULL;
        int   c, count;
        int   nret = 0;

		jmc_timestamp_t starttime;
		jmc_timefloat_t elapsedtime;

        nret = ReadEntireFileSafely(argv[1], "rb", &json_buffer_bak, NULL);
        if (nret) {
            printf("ReadEntireFileSafely[%s] failed[%d]\n", argv[1], nret);
            return nret;
        }
#if defined(_MSC_VER)
        json_buffer = _strdup(json_buffer_bak);
#else
        json_buffer = strdup(json_buffer_bak);
#endif
        if (json_buffer == NULL) {
            printf("strdup failed, errno[%d]\n" , errno);
            return 1;
        }
        json_len = strlen(json_buffer);

        count = atol(argv[2]) ;
        if (count > 0) {
            //time_t  t1 , t2 ;

            //time(&t1);
            starttime = jmc_get_timestamp();
            for (c = 0; c < count; c++) {
                rapidjson::Document doc;        // character type defaults to char
                doc.Parse<0>(json_buffer);      // 0 means default parse flags
                if (doc.HasParseError()) {
                    printf("error code: %d\n", doc.GetParseError());
                    return 2;
                }

                memcpy(json_buffer, json_buffer_bak, json_len);
            }
            elapsedtime = jmc_get_elapsedtime_msf(starttime);
            //time(&t2);
            printf("Elapse time is %0.3f ms\n", elapsedtime);
            //printf("Elapse %d seconds\n" , (int)(t2-t1));
        }
        else {
            int len;

            count = -count;
            len = 0;
            for (c = 0; c < count; c++) {
                len += strlen(json_buffer_bak);
            }
            printf("len[%d]\n", len);
        }
    }
    else {
        printf("USAGE : press_fastjson json_pathfilename press_count\n");
        exit(7);
    }

    return 0;
}
