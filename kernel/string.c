#include "types.h"

void* memset(void *dst, int c, uint n) {
  char *cdst = (char *) dst;
  for(uint i = 0; i < n; i++)
    cdst[i] = c;
  return dst;
}