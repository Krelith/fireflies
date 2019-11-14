import org.openkinect.processing.*;

Kinect kinect;

int w, h;
int leastX;
int leastY;

// Global vars
int fQty = 10;
boolean onScreenParams = true;

Firefly[] fireflies = new Firefly[fQty];

void setup() {
  //size(512, 480);
    //size(1000, 1000);
  kinect = new Kinect(this);
  kinect.initDepth();
  for (int i = 0; i < fQty; i++){
    fireflies[i] = new Firefly(random(width), random(height));
  }
}

void draw() {
  background(0);
  //for (int i = 0; i < fQty; i++){
  //  fireflies[i].show();
  //  fireflies[i].update();
  //  fireflies[i].evaluateMood();
  //}

  // Kinect stuff
  //Displays depth camera
  PImage img = kinect.getDepthImage();
  translate(img.width,0);
    scale(-1.0,1.0);
  image(img,0,0);

   w = img.width;
   h = img.height;

   //Gets depth data values 0-2048
  int[] depth = kinect.getRawDepth();

  //Find nearest point to center
  int leastDepth = -1;
  for(int i = 0; i < depth.length; i++){
    if(i == 0 || depth[i] < depth[leastDepth])
    leastDepth = i;
  }

  //Calculating Distance
  leastX = leastDepth % w;
  leastY = leastDepth/w;

  //If this close make ellipse this colour, if not other colour.
  if(leastY > 375 && leastX > 275){
      fill(255,0,0);
      ellipse(leastX,leastY,20,20);
  }else{
    fill(0,255,0);
  ellipse(leastX,leastY,20,20);
  }


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
