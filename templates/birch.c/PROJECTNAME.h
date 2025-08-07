/* PROJECTNAME.h */

#pragma once

#define _GNU_SOURCE

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <assert.h>
#include <errno.h>

typedef unsigned char int8;
typedef unsigned short int int16;
typedef unsigned int int32;
typedef unsigned long long int int64;

#define $1 (int8_t)
#define $2 (int16_t)
#define $4 (int32_t)
#define $8 (int64_t)
#define $c (char *)
#define $i (int *)

