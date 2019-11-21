import org.openkinect.processing.*;

Kinect kinect;

int w, h;
float leastX;
float leastY;
boolean tracking;

float[] depthLookUp;

// Global vars
int fQty = 10;
boolean onScreenParams = true;

Firefly[] fireflies = new Firefly[fQty];

void setup() {
  size(512, 480);
  //size(1024, 960);
  kinect = new Kinect(this);
  kinect.initDepth();
  for (int i = 0; i < fQty; i++){
    fireflies[i] = new Firefly(random(width), random(height));
  }
  tracking = false;

  depthLookUp = new float[2048];
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
}

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
  PImage img = kinect.getDepthImage();
   w = img.width;
   h = img.height;

  push();
  scale(-(float)width/w,(float)height/h);
  translate(-img.width,0);
  image(img,0,0);
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
  leastX = -((float)width/w) * (leastDepth % w);
  leastX += width;
  println(leastX);
  leastY = (height/h) * (leastDepth/w);


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
  text(depthVal,w/2,50);
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

}
