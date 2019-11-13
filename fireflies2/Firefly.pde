class Firefly {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector lastPos;
  float topspeed;
  float seed;
  
  Firefly(float x, float y) {
    // Start in the center
    location = new PVector(x,y);
    velocity = new PVector(0,0);
    lastPos = location;
    topspeed = 5;
    seed = random(1000);
  }
  
  void show() {
    noStroke();
    fill(255,250,69);
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
}
