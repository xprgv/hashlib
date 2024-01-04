#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../hash.h"

int main(int argc, char* argv[]) {
    if (argc < 3) {
        printf("Usage: ./hashf <hash_func> <data>\n");
        return 1;
    }

    if (!strcmp(argv[1], "krlose")) {
        printf("%u\n", hashf_krlose(argv[2]));
        return 0;
    }

    if (!strcmp(argv[1], "djb2")) {
        printf("%u\n", hashf_djb2(argv[2]));
        return 0;
    }

    if (!strcmp(argv[1], "sdbm")) {
        printf("%u\n", hashf_sdbm(argv[2]));
        return 0;
    }

    if (!strcmp(argv[1], "jenkins")) {
        printf("%u\n", hashf_jenkins_one_at_a_time(argv[2]));
        return 0;
    }

    printf("No such hash function: %s\n", argv[1]);
    return 0;
}
