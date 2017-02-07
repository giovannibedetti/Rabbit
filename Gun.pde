
public class Gun {
  int x, y;
  int rateY;
  int shootRate;
  PImage gunImage;
  PShape bImage;
  boolean started;
  float imgResize = 0.25;
  int bCount=0;
  Ani as;
  CarrotBullet[] cb; 
  int r;
  int g; //levels for lifeBar

  public Gun(PImage img, PShape bImg, int sRate) {
    init();
    gunImage = img;
    bImage=bImg;
    y=yPos;
    x=10;
    shootRate=sRate;
    reload(4);

    as = new Ani(this, 0, 0.3, "y", yPos, Ani.EXPO_IN, "onEnd:followRabbit");
    as.start();
  }

  public boolean death () {
    boolean res=false;
    if (r>=255&&g<=0) res = true;
    return res;
  }

  public void hit() {
    r+=8;
    g-=8;  
  }

  public int dying (int nChanges) {
    int res=0;
    for (int i=0;i<nChanges;i++) {
      if (r>(255/nChanges*i)) {
        res=i;
      }
    }
    return res;
  }

  public void reload(int n) {

    cb= new CarrotBullet[n];  //n bullets
    for (int i=0;i<cb.length;i++) {
      cb[i] = new CarrotBullet(bImage, x+gunImage.width*imgResize/2, y);
    }
  }

  public void reset() {
    r=0;
    g=255;
  }

  public void init() {
    r=0;
    g=255;
    started=false;
  }

  public void draw() {
    if (started) {

      image(gunImage, x, y, gunImage.width*imgResize, gunImage.height*imgResize);
      wait4shoot();
    }
  }

  public void drawBullets() {
    for (int i=0;i<cb.length;i++) {
      cb[i].draw();
    }
  }

  public void sequenceEnd() {
    println("sequenceEnd() restart all again");
    as.start();
  }

  public void gunStart() {
    started=true;
  }
  public void gunStop() {   
    started=false;
  }

  public void followRabbit(Ani _ani) {
    
    as.to(this, 0.3, "y", (yPos-cb[0].h/2), Ani.EXPO_IN, "onEnd:followRabbit");
  }

  public void shoot() {
   
    current=millis();
    startBullet();
  }

  void itsStarted() {
    println("animation started");
  }

  public void startBullet() {
    if (bCount<cb.length) {
      splut.trigger();
      cb[bCount].started=true;
      cb[bCount].y=y;
      bCount++;
    }
    else {
      bCount=0;
      gunStart();
    }
  }

  public void wait4shoot() {
    
    if (millis()-current>=shootRate) {
      shoot();
    }
  }
}