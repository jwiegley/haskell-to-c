#include <stdio.h>
#include <time.h>
#include "HsFFI.h"

struct Point
{
  time_t moment;
  double latitude;
  double longitude;
};

#ifdef __cplusplus
#include <vector>

class Track
{
  std::vector<Point> points;

public:
  Track(const std::vector<Point>& _points) : points(_points) {}
};
#else
struct Track
{
  struct Point *points;
};
#endif

#ifdef __cplusplus
extern "C"
#endif
void *c_initState(int);
#ifdef __cplusplus
extern "C"
#endif
void  c_freeState(void *);
#ifdef __cplusplus
extern "C"
#endif
char *c_processTrack(struct Track *, void *, void **);
