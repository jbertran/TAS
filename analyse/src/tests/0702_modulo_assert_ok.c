{
  int x;
  int y;
  x = rand(0,5);
  y = 2;
  x = x % y;
  assert(x>=2);
  print(x);
}
