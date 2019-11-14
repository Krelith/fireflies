import org.openkinect.processing.*;

Kinect kinect;

int w, h;

void setup(){
  size(512, 600);
  kinect = new Kinect(this);  
  kinect.initDepth();
}

void draw(){
  background(0);
  
  //Displays depth camera
  PImage img = kinect.getDepthImage();
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
  int leastY = leastDepth/w; int leastX = leastDepth % w;
  
  //If this close make ellipse this colour, if not other colour
  if(leastY > 300 && leastX < 220){
      fill(0,255,0);
      ellipse(leastX,leastY,20,20);
  }else{
    fill(255,0,0);
  ellipse(leastX,leastY,20,20);
  }
  
  //print("x:" + leastX + "   y:" + leastY);
  //delay(100);
}
