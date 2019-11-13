// Global vars
int fQty = 10;
boolean onScreenParams = true;

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
    fireflies[i].evaluateMood();
  }
  
  // On-screen params
  if (onScreenParams){
    fill(255);
    int notHappy = 0;
    for (int i = 0; i < fQty; i++){
      if (!fireflies[i].goodMood){
        notHappy++;
      } 
    }
    // If more than half of the fireflies are not happy, set Avg mood to agitated
    if (notHappy > fQty/2){
        text("Avg mood: Agitated", 20, height-10);
      } else {
        text("Avg mood: Relaxed", 20, height-10);
      } 
    if (mousePressed){
      text("Interaction loc: " + mouseX + ", " + mouseY, 20, height-30);   
    } else {
      text("Interaction loc: N/A", 20, height-30);
    }
  }
}

  
