class Firefly {
  /*
  CLASS NOTES:
 
  INTERACTION
  By default (no user interaction) the fireflies will aimlessly orbit the centre of
  the sketch. When a user interacts the fireflies will drift in that direction,
  ultimately orbiting the stable interaction point or following the most recent
  interaction point if it is moving. The firefly movement is random within the vicinity
  of the interaction point, and is calculated using vectors for location, acceleration,
  and velocity.
 
  MOOD
  Each firefly has a binary state of goodMood (happy/not happy). The threshold
  for the flip from good to bad is measured in frames according to the moodThreshold
  variable, and is compared against the moodTimer variable.
  Each firefly has its own random starting value for moodTimer, which is randomly reset
  when user interaction ceases. Doing it this way ensures each firefly has its own
  'fuse length', i.e. how little or much Human interaction it can take before it
  flips its proverbial lid.
  */
 
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector lastPos;
  float topspeed;
  float seed;
  boolean goodMood;
  int greenAmount;
  int moodTimer;
  int moodThreshold;
 
  Firefly(float x, float y) {
    // Start in the center
    location = new PVector(x,y);
    velocity = new PVector(0,0);
    lastPos = location;
    topspeed = 5;
    seed = random(1000);
    goodMood = true;
    greenAmount = 250;
    moodTimer = round(random(298));
    moodThreshold = 300;
  }
 
  void show() {
    if (goodMood){
      if (greenAmount < 250) greenAmount += 5;
    } else {
      if (greenAmount > 0) greenAmount -= 5;
    }
    //if (frameCount % 5 == 0){
    //  stroke(255);
    //  line(location.x + 15, location.y + 15, location.x + 35, location.y + 10);
    //  line(location.x + 15, location.y + 15, location.x - 5, location.y + 10);
    //  line(location.x + 15, location.y + 15, location.x + 35, location.y + 7);
    //  line(location.x + 15, location.y + 15, location.x - 5, location.y + 7);
     
    //}
    //noStroke();
  //  if (alpha == 100 || alpha == 255) { delta = -delta; }
  //alpha += delta;
  
    float circleTwoX = mouseX;
    float circleTwoY = mouseY;
    float circleTwoRadius = 2;
  
    if (dist(location.x, location.y, circleTwoX, circleTwoY) < 10 + circleTwoRadius) {
    //colliding!
    fill(255, 0, 0);
    file1.play();
  } else {
    //not colliding!
    fill(0, 255, 0);
    //file.stop();
  }
  
       ellipse(circleTwoX, circleTwoY, circleTwoRadius, circleTwoRadius);
       fill(255, greenAmount, 69);
       ellipse(location.x,location.y,10,10);
    //image(img, location.x, location.y, 30 ,30);
    tint(255, 240, 58);
  }

  void update() {
    PVector acceleration;
    if (mousePressed){
      PVector mouse = new PVector(mouseX,mouseY);
      lastPos = mouse;
      acceleration = PVector.sub(mouse,location);
    } else {
      float xPos = width * noise(seed + 1);
      float yPos = height * noise(seed - 1);
      lastPos = new PVector(xPos, yPos);
      acceleration = PVector.sub(lastPos,location);
    }
    acceleration.setMag(random(0.2));
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    seed += random(0.01);
  }
 
  void evaluateMood(){
    if (mousePressed){
      moodTimer++;
    } else {
      moodTimer = round(random(298));
    }
    if (moodTimer > moodThreshold){
      goodMood = false;
    } else {
      goodMood = true;  
    }
  }
}
