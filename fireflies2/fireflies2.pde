/* May require multiple startup attempts. If the tracking dot is moving then the program is good to go. */
/* Activating debug mode will crash the camera component and require a restart */

import org.openkinect.processing.*;
import processing.sound.*;

// Global vars
int fQty = 12; // Firefly qty
boolean onScreenParams = false; // Show on-screen parameters (debug)
Kinect kinect; // Set a kinect object
int depthImg_w, depthImg_h; // Set vars for depth image with and height
float leastX; // Closest depth pixel X pos
float leastY; // Closest depth pixel Y pos
boolean tracking; // Kinect is tracking a viable interaction
float[] depthLookUp; // Conversion values for real distance reading
Firefly[] fireflies = new Firefly[fQty]; // Initialise firefly array (to hold objects)
boolean showDepthImg;
SoundFile[] sounds = new SoundFile[8];
int currentFrame = 0;
int referenceFrame = 0;
String collision = "false";
boolean showDebug = true;
PImage fireflyImg;

void setup() {
  size(1920, 1080); // Canvas size
  ellipseMode(RADIUS);
  kinect = new Kinect(this); // Instantiate kinect using Kinect class
  kinect.initDepth(); // Initialise depth tracking
  for (int i = 0; i < fQty; i++){
    fireflies[i] = new Firefly(random(width), random(height)); // Instantiate firefly objects within the aforementioned array
  }
  tracking = false; // Default tracking boolean to false
  depthLookUp = new float[2048]; // Initialise depthLookUp array
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i); // Populate depthLookUpArray using the below function to calculate values
  }
  showDepthImg = false;
  
  // Sound
  sounds[0] = new SoundFile(this, "Piano.ff.E5.aiff");  
  sounds[1] = new SoundFile(this, "Piano.mf.Gb5.aiff");  
  sounds[2] = new SoundFile(this, "Piano.ff.Ab5.aiff");  
  sounds[3] = new SoundFile(this, "Piano.ff.A5.aiff");  
  sounds[4] = new SoundFile(this, "Piano.ff.B5.aiff");  
  sounds[5] = new SoundFile(this, "Piano.pp.Db6.aiff");  
  sounds[6] = new SoundFile(this, "Piano.mf.Eb6.aiff"); 
  sounds[7] = new SoundFile(this, "Piano.ff.D5.aiff");
  fireflyImg = loadImage("firefly.png");
}

// Function to calculate real depth values (in metres)
float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}

void draw() {
  background(0);
  
  // Kinect stuff
  //Displays depth camera
  PImage depthImg = kinect.getDepthImage();
  depthImg_w = depthImg.width;
  depthImg_h = depthImg.height;

  push();
  scale(-(float)width/depthImg_w,(float)height/depthImg_h);
  translate(-depthImg_w,0);
  if (showDepthImg){
    image(depthImg,0,0);
  }
  pop();
  
  for (int i = 0; i < fQty; i++){
    fireflies[i].show();
    fireflies[i].update();
    fireflies[i].evaluateMood();
  }

   //Gets depth data values 0-2048
  int[] depth = kinect.getRawDepth();

  //Find nearest point to center
  int leastDepth = -1;
  float depthVal = -1;
  for(int i = 0; i < depth.length; i++){
    if(i == 0 || depth[i] < depth[leastDepth])
    leastDepth = i;
    depthVal = depthLookUp[depth[leastDepth]];
  }

  //Calculating Distance
  //println(leastDepth % w);
  leastX = -((float)width/depthImg_w) * (leastDepth % depthImg_w);
  leastX += width;
  //println(leastX);
  leastY = (height/depthImg_h) * (leastDepth/depthImg_w);


  //If this close make ellipse this colour, if not other colour.
  if(depthVal < 2.0 && depthVal > 0.8){
    tracking = true;
    fill(255,0,0);
    //ellipse(leastX,leastY,20,20);
  }else{
    tracking = false;
    fill(0,255,0);
    //ellipse(leastX,leastY,20,20);
  }
  if (showDebug){
    ellipse(leastX, leastY, 20,20);
  }

  if (showDebug){
    textSize(32);
    fill(250,240,70);
    text(depthVal, depthImg_w / 2 ,50);
    text("Current frame: " + currentFrame,100,130);
    text("Reference frame: " + referenceFrame, 100, 160);
    text("Has collided once: " + collision, 100, 190);
    text("locx = " + fireflies[0].location.x, 100, 220);
    text("locy = " + fireflies[0].location.y, 100, 250);
    text("inputx = " + leastX, 100, 280);
    text("inputy = " + leastY, 100, 310);
    text("Distance: " + dist(fireflies[0].location.x, fireflies[0].location.y, leastX, leastY), 100, 340);
    text("Tracking x: " + (width - fireflies[0].location.x), 100, 370);
    //rect(leastX, leastY, 10,10);
    //fill(0,0,255);
    //rect(width - fireflies[0].location.x, fireflies[0].location.y, 10,10);
  }
  if (currentFrame - referenceFrame >= 40 && tracking){
    referenceFrame = currentFrame;
    float circleTwoRadius = 50;
    for (int i = 0; i < fireflies.length; i++){
      if (dist(width - fireflies[i].location.x, fireflies[i].location.y, leastX, leastY) < circleTwoRadius) {
        collision = "true";
        //colliding!
        int randFlat = floor(random(0,8));
        sounds[randFlat].play();
      } else {
        collision = "false";  
      }
    }
  }
  currentFrame++;
}

void keyPressed(){
  if (keyCode == DOWN){
    if (showDepthImg){
      showDepthImg = false;
      println("Hide depth img");
    } else {
      showDepthImg = true;
      println("Show depth img");
    }
  }
  if (keyCode == UP){
    if (showDebug){
      showDebug = false;  
    } else {
      showDebug = true;  
    }
  }
}
