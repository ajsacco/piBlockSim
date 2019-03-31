import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Pi extends PApplet {

/*=========OPTIONS=========*/
double n = 7; //Mass of larger box is 100^n

double speed = Math.pow(100, n/2); //Simulation speed in calculations per frame
/*=========================*/


float box1size = 200;
float box2size = box1size/3.0f;
Box big;
Box small;
float strokeWeight = 1.0f;
int num;
float prop = 1.3f;
double nMass = (double)(Math.pow(100, n));

public void setup(){
  
  
  big = new Box(width/2, -2.0f/speed, nMass, height, box1size, 255, 0, 0, prop, strokeWeight);
  small = new Box((int)(width/2-2*box2size), 0.0f, 1.0f, height, box2size, 0, 0, 255, prop, strokeWeight);
}

public void draw(){
  background(200, 200, 200);
  pushMatrix();
  scale(3.0f);
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
  
  public void show(){
    stroke(0);
    strokeWeight(stroke);
    fill(red, green, blue);
    rect((int)(posX), canvasH/prop-size, size, size);
  }
  
  public void setVel(double v){
    velocity = v;
  }
  
  public void move(){
    posX += velocity;
  }
  
  public boolean wall(){
    if(small.posX < 0.0f){
      velocity = -velocity;
      return true;
    }
    return false;
  }
  
  public boolean collide(Box small){
    if(big.posX - small.posX < small.size){
      double smallOldV = small.velocity;
      double bigOldV = velocity;
      this.setVel(2.0f*small.mass*smallOldV/(small.mass+this.mass) + (this.mass-small.mass)*bigOldV/(small.mass+this.mass));
      small.setVel(2.0f*this.mass*bigOldV/(this.mass+small.mass) + (small.mass-this.mass)*smallOldV/(this.mass+small.mass));
      return true;
    }
    return false;
  }
}
  public void settings() {  size(1000, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Pi" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
