#include <stdio.h>
#include "HsFFI.h"

extern void *c_initState(int);
extern char *c_sampleMethod(int, void *, void **);

int main(int argc, char *argv[]) {
  hs_init(&argc, &argv);

  void *state = c_initState(50);

  char *result = c_sampleMethod(100, state, &state);
  printf("Result = %s\n", result);

  result = c_sampleMethod(200, state, &state);
  printf("Result = %s\n", result);

  result = c_sampleMethod(300, state, &state);
  printf("Result = %s\n", result);

  hs_exit();
}
