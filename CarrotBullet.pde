public class CarrotBullet {

  float x;
  float y;
  float w;
  float h;
  float centerX, centerY;
  float speedX;
  float speedY;
  PShape cBullet;
  Boolean started;

  public CarrotBullet(PShape _img, float _x, float _y) {
    started=false;
    cBullet = _img;
    x=_x;
    y=_y;
    w=_img.width*0.6;
    h=_img.height*0.6;
    speedX=30;
    speedY=0;
    centerX=x+w/2;
    centerY=y+h/2;
  }

  public void draw() {
    if (started) {
      
      
      x+=speedX;
      centerX=x+w/2;
      centerY=y+h/2;
      //y+=speedY;

      shape(cBullet, centerX, centerY, w, h);
      
      if(debugOn){
        noFill();
          strokeWeight(1);
          stroke(0, 255, 50);
          rect(x, y, w, h);
          strokeWeight(10);
          point(centerX, centerY);        
      }
      
      if (x>width) {
        started=false;  
        x=gun.x+gun.gunImage.width*gun.imgResize;        
      }
    }
  }

  public boolean rollover(int mx, int my) {
    boolean hit=false;
    if (mx > x && mx < x + w && my > y && my < y + h && started ) {
      hit = true;      
    }
    return hit;
  }
}