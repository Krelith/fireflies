public class Firefly {
  float x;
  float y;
  float seed;
  
  public Firefly(float x, float y, float seed){
    this.x = x;
    this.y = y;
    this.seed = seed;
  }
  
  public void show(){
    noStroke();
    fill(255,250,69,150);
    ellipse(this.x,this.y, 10, 10);
    fill(255,250,69,255);
    ellipse(this.x,this.y, 5, 5);
  }
   
  public void update(){
    /* Get Mouse */
    
    /* ======== */
    float xPos = 0;
    float yPos = 0;
    xPos = width * noise(this.seed + 1);
    yPos = height * noise(this.seed - 1);
    println(this.seed + ", " + noise(this.seed));
    this.x = xPos;
    this.y = yPos;
    this.seed += random(0.01);
  }
}
