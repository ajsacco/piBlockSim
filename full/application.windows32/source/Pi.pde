import javax.swing.*;

double n;
double speed;
float strokeWeight = 2.0;
float prop = 1.3333;
float box1size = 200;
double custVel = -2.0;
double simScale = 1.0;
float box2size;
float boxProp = 0.333;
Box big;
Box small;
int num;
double nMass;
boolean exit = false;
boolean start = false;

void setup(){
  String input = JOptionPane.showInputDialog("How many digits of Pi?"); //<>//
  if(input != null && input.equals("dev")){
    while(!exit){
      int option = intPane("Developer Options:\n1. Velocity\n2. Simulation Speed\n3. Large Box Size\n4. Small Box Size\n5. Box Outline Width\n6. Ground Height\n7. Exit");
      switch(option){
        case 1: custVel = dPane("Enter custom velocity (default is 2.0):\n<html><b>MUST BE NEGATIVE</b></html>");
          break;
        case 2: simScale = dPane("Enter custom simulation speed (default is 1):"); //Simulation speed in calculations per frame
          break;
        case 3: box1size = fPane("Enter custom large box size (default is 200):"); //Size of larger box in pixels
          break;
        case 4: boxProp = fPane("Enter custom proportion of small box to large box [0.0 - 1.0] (default is 0.333):");
          break;
        case 5: strokeWeight = fPane("Enter custom stroke weight (default is 1.0):");
          break;
        case 6: prop = 1/fPane("Enter custom ground height [0.0 - 1.0] (default is 0.77):");
          break;
        case 7: exit = true;
          break;
        default:
          break;
      }
      if(exit) n = dPane("How many digits of Pi?");
    }
  } else {
    n = Double.parseDouble(input); //Mass of larger box is 100^n
  }
  
  speed = Math.pow(100, n/2*simScale); //Simulation speed in calculations per frame
  box2size = box1size*boxProp;
  nMass = (double)(Math.pow(100, n));

  size(1000, 600);
  big = new Box(width/2, custVel/speed, nMass, height, box1size, 255, 0, 0, prop, strokeWeight);
  small = new Box((int)(width/2-2*box2size), 0.0, 1.0, height, box2size, 0, 0, 255, prop, strokeWeight);
  start = true;
}

void draw(){
  if(start){
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
    
    if(small.velocity > 0 && big.velocity > 0 && big.velocity > small.velocity){
      start = false;
      stop();
      end();
    }
  }
}

int intPane(String query){
  try {
    return Integer.parseInt(JOptionPane.showInputDialog(query));
  } catch (Exception e){
    return -1;
  }
}

float fPane(String query){
  try {
    return Float.parseFloat(JOptionPane.showInputDialog(query));
  } catch (Exception e){
    return -1.0;
  }
}

double dPane(String query){
  try {
    return Double.parseDouble(JOptionPane.showInputDialog(query));
  } catch (Exception e){
    return -1.0;
  }
}

void end(){
  JOptionPane.showMessageDialog(null, "pi = " + piFormat(num));
}

String piFormat(int pie) {
  String p = Integer.toString(pie);
  return p.substring(0, 1) + "." + p.substring(1);
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
