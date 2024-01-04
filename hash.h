#ifndef _HASH_H
#define _HASH_H

#include <stdint.h>
#include <stdio.h>

typedef uint32_t Hash;

extern Hash hashf_krlose(const char* str);
extern Hash hashf_djb2(const char* str);
extern Hash hashf_sdbm(const char* str);
extern Hash hashf_jenkins_one_at_a_time(const char* str);

#endif
