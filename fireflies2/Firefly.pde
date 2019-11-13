class Firefly {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector lastPos;
  float topspeed;
  float seed;
  boolean goodMood;
  int greenAmount;
  
  Firefly(float x, float y) {
    // Start in the center
    location = new PVector(x,y);
    velocity = new PVector(0,0);
    lastPos = location;
    topspeed = 5;
    seed = random(1000);
    goodMood = true;
    greenAmount = 250;
  }
  
  void show() {
    if (goodMood){
      if (greenAmount < 250) greenAmount += 5;
    } else {
      greenAmount -= 5;
    }
    if (frameCount % 5 == 0){
      stroke(255);
      line(location.x - 10, location.y - 3, location.x, location.y);
      line(location.x + 10, location.y - 3, location.x, location.y);
      line(location.x - 10, location.y, location.x, location.y);
      line(location.x + 10, location.y, location.x, location.y);
    }
    noStroke();
    fill(255, greenAmount, 69);
    ellipse(location.x,location.y,10,10);
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
  
  void setMood(){
    if (mousePressed){
      goodMood = false;  
    } else {
      goodMood = true;  
    }
  }
}
