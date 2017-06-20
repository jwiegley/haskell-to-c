#include <stdio.h>
#include "HsFFI.h"

extern char *c_sampleMethod(int);

int main(int argc, char *argv[]) {
  hs_init(&argc, &argv);

  char *result = c_sampleMethod(100);
  printf("Result = %s\n", result);

  hs_exit();
}
