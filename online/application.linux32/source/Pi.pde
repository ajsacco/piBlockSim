/*=========OPTIONS=========*/
double n = 7; //Mass of larger box is 100^n

double speed = Math.pow(100, n/2); //Simulation speed in calculations per frame
/*=========================*/


float box1size = 200;
float box2size = box1size/3.0;
Box big;
Box small;
float strokeWeight = 1.0;
int num;
float prop = 1.3;
double nMass = (double)(Math.pow(100, n));

void setup(){
  size(1000, 600);
  
  big = new Box(width/2, -2.0/speed, nMass, height, box1size, 255, 0, 0, prop, strokeWeight);
  small = new Box((int)(width/2-2*box2size), 0.0, 1.0, height, box2size, 0, 0, 255, prop, strokeWeight);
}

void draw(){
  background(200, 200, 200);
  pushMatrix();
  scale(3.0);
  fill(0);
  text(num, 25, 15);
  popMatrix();
  stroke(255);
  strokeWeight(strokeWeight);
  fill(255);
  rect(0, height/prop+strokeWeight, width, height-height/prop+strokeWeight);
  
  for(int i = 0; i < speed; i++){
    if(big.collide(small)) num++;
    if(small.wall()) num++;
    big.move();
    small.move();
  }
  big.show();
  small.show();
}


class Box {
  double posX;
  double velocity;
  double mass;
  float size;
  int canvasH;
  int red;
  int green;
  int blue;
  float stroke;
  float prop;
  boolean one;
  PShape shape;
  
  Box(int x, double v, double m, int h, float s, int r, int g, int b, float p, float sw){
    posX = x;
    velocity = v;
    mass = m;
    size = s;
    canvasH = h;
    stroke = sw;
    red = r;
    green = g;
    blue = b;
    prop = p;
  }
  
  void show(){
    stroke(0);
    strokeWeight(stroke);
    fill(red, green, blue);
    rect((int)(posX), canvasH/prop-size, size, size);
  }
  
  void setVel(double v){
    velocity = v;
  }
  
  void move(){
    posX += velocity;
  }
  
  boolean wall(){
    if(small.posX < 0.0){
      velocity = -velocity;
      return true;
    }
    return false;
  }
  
  boolean collide(Box small){
    if(big.posX - small.posX < small.size){
      double smallOldV = small.velocity;
      double bigOldV = velocity;
      this.setVel(2.0*small.mass*smallOldV/(small.mass+this.mass) + (this.mass-small.mass)*bigOldV/(small.mass+this.mass));
      small.setVel(2.0*this.mass*bigOldV/(this.mass+small.mass) + (small.mass-this.mass)*smallOldV/(this.mass+small.mass));
      return true;
    }
    return false;
  }
}
