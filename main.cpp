#include "main.h"

int main(int argc, char *argv[])
{
  hs_init(&argc, &argv);

  void *state = c_initState(50);

  for (int i = 0; i < 3; i++)
  {
    Point p1 = { 1, 1.0, 2.0 };
    Point p2 = { 2, 1.0, 2.0 };
    std::vector<Point> v;
    v.push_back(p1);
    v.push_back(p2);
    Track track(v);

    char *result = c_processTrack(&track, state, &state);
    printf("Result = %s\n", result);
  }

  c_freeState(state);

  hs_exit();
}
