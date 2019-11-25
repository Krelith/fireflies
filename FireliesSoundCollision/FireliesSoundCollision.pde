// Global vars
import processing.sound.*;
SoundFile file1, file2;
float r;
int fQty = 30;
boolean onScreenParams = true;
PImage img;
int alpha = 101, delta = 1;


SoundFile[] sounds = new SoundFile[2];
Firefly[] fireflies = new Firefly[fQty];

void setup() {
  size(800,600);
  sounds[0] = new SoundFile(this, "0.mp3");  
  sounds[1] = new SoundFile(this, "4.mp3");  
  ellipseMode(RADIUS);
  noStroke();
  //img = loadImage("firefly2.png");
  for (int i = 0; i < fQty; i++){
    fireflies[i] = new Firefly(random(width), random(height));  
  }
}

void draw() {
  background(0);
  // // Displays the image at its actual size at point (0,0)

  //// Displays the image at point (0, height/2) at half of its size
  //image(img, 0, height/2, img.width/2, img.height/2);
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
