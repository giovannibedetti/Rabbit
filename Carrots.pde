public class Carrots {

  int x;
  int y;
  int w;
  int h;
  int n;
  int centerX;
  int centerY;
  boolean eaten;
  boolean visible;
  boolean triggered;
  PShape carrotImg;

  public Carrots(PShape _carrot, int _n) {
    carrotImg = _carrot;
    x=round(random(200, width-200));
    y=round(random(200, height-200));
    w=width/40;
    h=height/9;
    n=_n;
    centerX=x+w/2;
    centerY=y+h/2;
    visible=false;
    eaten=false;
  }

  public void draw() {  
    if (!visible) {
    } 
    else {
      if (!eaten) {
        shape(carrotImg, centerX, centerY, w, h);
        if (debugOn) {
          noFill();
          strokeWeight(1);
          stroke(0, 255, 50);
          rect(x, y, w, h);
          strokeWeight(10);
          point(centerX, centerY);
        }
      }
      else if (!triggered) {
        int r=round(random(sampleArray.length-1));
        sampleArray[r].trigger();
        if (!(battle.isPlaying()))
          eatenArray[n%eatenArray.length].trigger();
        triggered=true;
      }
      else {
        //wait
      }
    }
  }


  public void rollover(int mx, int my) {
    if (mx > x && mx < x + w && my > y && my < y + h) {
      eaten = true;      
    }
  }
}