#include <iostream>

int add(int x, int y) {
  return x + y;
}

int main() {
  int x = 0;

  // ÇóÀÛ¼ÓºÍ
  
  for (int i = 0; i < 10; ++ i) {
    x = add(x, i);
  }

  return 0;
}
