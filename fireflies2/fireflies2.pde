/* May require multiple startup attempts. If the tracking dot is moving then the program is good to go. */
/* Activating debug mode will crash the camera component and require a restart */

import org.openkinect.processing.*;

// Global vars
int fQty = 10; // Firefly qty
boolean onScreenParams = false; // Show on-screen parameters (debug)
Kinect kinect; // Set a kinect object
int depthImg_w, depthImg_h; // Set vars for depth image with and height
float leastX; // Closest depth pixel X pos
float leastY; // Closest depth pixel Y pos
boolean tracking; // Kinect is tracking a viable interaction
float[] depthLookUp; // Conversion values for real distance reading
Firefly[] fireflies = new Firefly[fQty]; // Initialise firefly array (to hold objects)
boolean showDepthImg;

void setup() {
  size(1920, 1080); // Canvas size
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
    ellipse(leastX,leastY,20,20);
  }else{
    tracking = false;
    fill(0,255,0);
    ellipse(leastX,leastY,20,20);
  }

  textSize(32);
  fill(250,240,70);
  text(depthVal, depthImg_w / 2 ,50);
  //println(depthVal);
  //println("x:" + leastX + "   y:" + leastY);

  // On-screen params
  /*
  //if (onScreenParams){
  //  fill(255);
  //  int notHappy = 0;
  //  for (int i = 0; i < fQty; i++){
  //    if (!fireflies[i].goodMood){
  //      notHappy++;
  //    }
  //  }
  //  // If more than half of the fireflies are not happy, set Avg mood to agitated
  //  if (notHappy > fQty/2){
  //      text("Avg mood: Agitated", 20, height-10);
  //    } else {
  //      text("Avg mood: Relaxed", 20, height-10);
  //    }
  //  if (mousePressed){
  //    text("Interaction loc: " + mouseX + ", " + mouseY, 20, height-30);
  //  } else {
  //    text("Interaction loc: N/A", 20, height-30);
  //  }
  //}*/
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
}
