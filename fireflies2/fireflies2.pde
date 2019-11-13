// Global vars
int fQty = 10;

Firefly[] fireflies = new Firefly[fQty];

void setup() {
  size(800,600);
  for (int i = 0; i < fQty; i++){
    fireflies[i] = new Firefly(random(width), random(height));  
  }
}

void draw() {
  background(0);
  for (int i = 0; i < fQty; i++){
    fireflies[i].show();
    fireflies[i].update();
    fireflies[i].setMood();
  }
}

  
