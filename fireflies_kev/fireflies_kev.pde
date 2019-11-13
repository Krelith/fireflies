// Firefly quantity (how many fireflies appear on-screen)
int fQty = 10;

Firefly[] fireflies = new Firefly[fQty];

void setup(){
  size(800,600);
  ellipseMode(CENTER);
  for (int i = 0; i < fireflies.length; i++){
    float xPos = random(width);
    float yPos = random(height);
    fireflies[i] = new Firefly(xPos, yPos, random(1000));
  }
}

void draw(){
  background(0);
  for (int i = 0; i < fireflies.length; i++){
    fireflies[i].show();
    fireflies[i].update();
  }
}

void mousePressed(){

}
