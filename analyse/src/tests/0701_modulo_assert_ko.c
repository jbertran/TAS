{
  int x;
  int y;
  x = rand(0,5);
  y = 6;
  x = x % y;
  assert(x==2);
  print(x);
}
