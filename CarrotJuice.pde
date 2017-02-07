public class CarrotJuice {

  float x;
  float y;
  float w;
  float h;
  color c;
  float level;
  boolean started;
  int time;
  PShape glass;
  
  public CarrotJuice(int _time) {
    time = _time;
    started=false;

    y=height/16*10;
    w=width/14;
    h=height/6;
    x=width/2;
    glass=loadShape("rabbit_bicchiere.svg");
  }

  public void draw(int curr) {
    level=map(curr, 0, time, 0, h);
    noStroke();
    fill(#EB6D1D);
    rect(x-w/2, y-h/3.0+level, w, h-level);
    shape(glass, x, y);
    noFill();
    stroke(255);
    strokeWeight(2);
    float r=random(5, 10);
    ellipse(random(x-w/2, x+w/2), random(y-h/3+level, y-h/3.0+h), r, r);
  }
}