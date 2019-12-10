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
    goodMood = false;
    greenAmount = 250;
    moodTimer = round(random(298));
    moodThreshold = 300;
  }
  
  void show() {
    // Draw intermittent wings
    if (frameCount % 5 == 0){
      stroke(255);
      line(width - location.x - 1, location.y - 3, width - location.x - 30, location.y);
      line(width - location.x + 30, location.y, width - location.x, location.y);
      line(width - location.x + 30, location.y - 10, width - location.x, location.y);
      line(width - location.x - 1, location.y, width - location.x - 30, location.y - 10);
    }
    
    //ellipse(circleTwoX, circleTwoY, circleTwoRadius, circleTwoRadius);
    
    // Draw ellipse
    int imgAdj = 15;
    noStroke();
    fill(255, greenAmount, 69);
    ellipse(width - location.x, location.y, 10, 10);
    //image(fireflyImg, width - location.x - imgAdj, location.y - imgAdj, 30, 30);
  }

  void update() {
    
      
    // Eval acceleration based on interaction
    PVector acceleration;
    if (tracking) {
      PVector mouse = new PVector(width - leastX, leastY);
      lastPos = mouse;
      acceleration = PVector.sub(mouse, location);
    } else {
      float xPos = width * noise(seed + 1);
      float yPos = height * noise(seed - 1);
      lastPos = new PVector(xPos, yPos);
      acceleration = PVector.sub(lastPos, location);
    }
    // Calculate new results
    acceleration.setMag(random(0.2));
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    // Increase randomisation seed
    seed += random(0.01);
    // Behaviour adjustments
    if (goodMood){
      // Return to yellow
      if (greenAmount < 250) greenAmount += 1;
    } else {
      // Change to red
      if (greenAmount > 0) greenAmount -= 5;
      // Have a fit
      if (greenAmount < 30){
        location.x += random(-8, 8);
        location.y += random(-8, 8);
      }
    }
  }
  
  void evaluateMood(){
    // Set/adjust mood timer (time to unhappy mood)
    if (tracking) {
      moodTimer++;
      referenceFrame = frameCount;
      //goodMood = true;
    } else {
      if (frameCount - referenceFrame > 60) moodTimer = round(random(298));
      //goodMood = false;
    }
    // Set mood
    if (moodTimer < moodThreshold){ 
      goodMood = false;
    } else {
      goodMood = true;  
    }
  }
}
