
void loadFonts() {
  
  font = createFont("GothamHTF-Black.otf", fontScoreDim); 
  textFont(font);
  textAlign(CENTER);
  fontResult = createFont("GothamHTF-Black.otf", fontResultDim);
}

void loadImages() {
  bullet=loadShape("rabbit_carota_proiettile.svg");
  carrot=loadShape("rabbit_carota_campo.svg");
  text_perfect=loadShape("text_perfect.svg");
  text_perfect_game=loadShape("text_perfect_game_100.svg");
  text_youwon=loadShape("text_youwon.svg");
  text_level_completed=loadShape("text_level_completed.svg");
  text_loser=loadShape("text_loser.svg");
  for (int i = 0;i<levels;i++) {
    text_level[i] = loadShape("rabbit_level_"+(i+1)+".svg");
  }
  bg=loadImage("rabbit_sfondo_colline.jpg");
  bg.resize(width, height);

  //bg=loadShape("rabbit_sfondo_colline.svg");

  gunImg=loadImage("pistola.png");
  bottomImage=loadImage("rabbit_title-01-10%.png");

  for (int i=0;i<nCuts;i++) {
    carrotLife[i] = loadShape("carota_vita_"+i+".svg");
  }
  for (int k=0;k<framesL.length;k++) {
    framesL[k]=loadImage("rabbit_bianco_taglio"+k/(framesL.length/nCuts)+"-"+k%nCuts+".png");
  }
  for (int k=0;k<framesR.length;k++) {
    framesR[k]=loadImage("rabbit_bianco_taglio"+k/(framesR.length/nCuts)+"-"+((k+framesR.length/nCuts)%nCuts+nCuts)+".png");
  }
}

void initOpenCV() {
  //opencv init
    video = new Capture(this, captureW, captureH);
  opencv = new OpenCV(this, captureW, captureH);
  //opencv = new OpenCV( this );
 // opencv.capture( captureW, captureH );                   // open video stream
  //  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT_TREE);
  opencv.loadCascade( OpenCV.CASCADE_FRONTALFACE);
  //opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT2);
  //opencv.cascade( OpenCV.CASCADE_FRONTALFACE_DEFAULT);
  //opencv.cascade( OpenCV.CASCADE_PROFILEFACE);        //best detection
  //opencv.cascade( OpenCV.CASCADE_FULLBODY);
  //opencv.cascade( OpenCV.CASCADE_LOWERBODY);
  //opencv.cascade( OpenCV.CASCADE_UPPERBODY);
  video.start();
}

void death() {
  winCount=0;                                 //set level to 0
  nCarrots=defaultCarrots;
  if (millis()-current<=timeForComeBack) {    //wait  until rabbit is alive
    if (battle.isPlaying()) {
      battle.pause(); 
      battle.cue(0);
    }

    if (!drinkingTriggered) {        // if RABBIT IS DEAD trigger DEATH samples
      drinkingTriggered=true; 
      drinking.trigger();
      rabbit_death.trigger();
    }
    carrotJuice.draw(millis()-current);
    
    shape(text_loser, width/2, height/3);
    printResults(width/2-fontScoreDim*2, height/16*13);
  }
  else {
    drinkingTriggered=false;
    rabbitAlive();
    rabbitOn=0;
    if (gun.started) gun.init();
  }
}

void drawBottomBar() {
  
  //draws current level on the bottom 
  if (winCount>0&&!endGame) {
    shape(text_level[winCount-1], width/2, height/10*9);
    float carrotW = carrotLife[gun.dying(nCuts)].width*0.45;
    float carrotH = carrotLife[gun.dying(nCuts)].height*0.45;
    //draws the carrot lifebar
    shape(carrotLife[gun.dying(nCuts)], width/2-carrotW/2, height/10*9-carrotH/2, carrotW, carrotH);
  }
  //draws the rabbit logo
  image(bottomImage, width/2-bottomImage.width/2, height/10-bottomImage.height/2);  
}



public void stop() {
  video.stop();
  minimStop();
  super.stop();
}

public void opencvCapture() {
 // scale(width/(float)captureW, height/(float)captureH);
  
  opencv.loadImage(video);
  opencv.flip( OpenCV.HORIZONTAL );
  //opencv.threshold(thresh);
  
  //opencv.brightness(bright);
  //opencv.contrast(contrast);
}

void captureEvent(Capture c) {
  c.read();
}

public int mediumCarrotPos() {
  int res=0;
  int divider=0;
  for (int i=0;i<nCarrots;i++) {
    if (!carrots[i].eaten) {
      res+=carrots[i].x;
      divider++;
    }
  } 
  if (divider>0) res/=divider; 
  else res/=1;
  return res;
}

public void winReset() {
  gun.reset();
}

public void win() {

  if (allEaten(carrots)) {                //check if all carrots are eaten->victory!
    if  (gun.r==0) {                     //check if it was perfect
      rabbitOn=0;                          //resets gun come back
      perfect=true;                        //perfect game!
    }

    if (winCount<levels) {                                      //scan levels
      results[winCount-1]=round(map(gun.r, 0, 255, 100, 0));      //save results
      nCarrots+=winCount;                                       //increase carrots number
      if (battle.isPlaying()) {                                //stop battle player in case it's playing
        battle.pause(); 
        battle.cue(0);
      }
      allEaten.trigger();                                      //trigger win level sounds
      allEatenFx.trigger();
      gun.init();                                              //init gun
      gunCurrent=millis();                                     
      showWin=true;
      newCarrots();  
      wait4Carrots();
    }
    else {
      results[winCount-1]=round(map(gun.r, 0, 255, 100, 0));
      endGame=true;
      nCarrots=defaultCarrots;
      winCount=1;
      if (battle.isPlaying()) {                                //stop battle player in case it's playing
        battle.pause(); 
        battle.cue(0);
      }

      rabbit_win.trigger();                 
      allEatenFx.trigger(); 
      gun.init();                                              //init gun
      gunCurrent=millis();
      showWin=true;
      newCarrots(); 
      wait4End();
    }
  }
}

void detectFaces() {
  if (debugOn){
    pushMatrix();
    scale(-1, 1);
    image( video, -video.width, 0 );      //show cam
    popMatrix();
  }
  Rectangle[] faces = opencv.detect( );//1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40);
  for ( int i=0; i<faces.length; i++ ) {        //scan all faces detected
    int wRabbit = round(faces[i].width*(width/captureW)*wScaler);
    int hRabbit = round(faces[i].height*(height/captureH));
    int xRabbit = round(map(faces[i].x, 0, captureW-faces[i].width, 0, width-wRabbit));
    int yRabbit = round(map(faces[i].y, 0, captureH-faces[i].height, 0, height-hRabbit));
    yPos = yRabbit+hRabbit/2;    //update global position to be tracked by gun

    //draw rabbit - choose the right rabbit image
    if (mediumCarrotPos()<=xRabbit) {
      image( framesL[((faces[i].x/animSpeed)%(nFramesL/nCuts))+nCuts*gun.dying(nCuts)], xRabbit, yRabbit, wRabbit, hRabbit);
    }
    else {
      image( framesR[(faces[i].x/animSpeed)%(nFramesR/nCuts)+nCuts*gun.dying(nCuts)], xRabbit, yRabbit, wRabbit, hRabbit);
    }

    //debug stuff
    noFill();
    strokeWeight(1);
    stroke(255, 0, 0);
    if (debugOn) { 
      //println(faces.length);
      pushMatrix();
        scale(-1, 1);
        rect(-(faces[i].x+faces[i].width), faces[i].y, faces[i].width, faces[i].height );    //rect on capture
      popMatrix();
      //rect on rabbit
      rect( xRabbit, yRabbit, wRabbit, hRabbit);
      strokeWeight(10);  
      //point on rabbit
      point(xRabbit+wRabbit/2, yRabbit+hRabbit/2);
    }

    for (int j=0;j<nCarrots;j++) {        //check if rabbit eats a carrot
      carrots[j].rollover(xRabbit+wRabbit/2, yRabbit+hRabbit/2);
    }

    for (int k=0;k<gun.cb.length;k++) {  //check if bullet hits rabbit            
      if (gun.cb[k].started&&gun.cb[k].rollover(xRabbit+wRabbit/2, yRabbit+hRabbit/2)) {
        oh.trigger();
        gun.hit();
        if (gun.death()) {        //check if rabbit is dead          //PULLS DEATH
          dead=true;
          current=millis();
        }
      }
    }
  }  //END SCAN FACES

  if (faces.length>0) {        //if some faces are detected, increase this threshold
    rabbitOn++;                //gun will wait until it is 200 before attacking
    //if faces detected for a long time, probably gun will stay on screen until a perfect is done
  }
  else { 
    if (rabbitOn<0) rabbitOn=0;   //avoid the threshold to go under 0
    else {
      rabbitOn--;
    }
  }
}

void gunTimer() {
  if (millis()-gunCurrent>=5000) {    // TIMER FOR GUN TO COME ACTIVE AND LOOKING FOR RABBIT
    gun.gunStart();
  }
}

void drawGunAndBullets() {
  gun.drawBullets();        //always draw bullets, even if gun is off

  if (rabbitOn>rabbitOnWait) {    //WAIT UNTIL RABBIT HAS BEEN VISIBLE FOR SOME TIME
    gun.draw();         //then draw gun
    if (gun.started) if (!(battle.isPlaying())) battle.loop();          //if gun was already started
  }
  else { 
    if (battle.isPlaying()) {    // check if battle music is still going, in case stop it
      battle.pause(); 
      battle.cue(0);
    }
  }
}

void drawCarrots() {
  for (int j=0;j<nCarrots;j++) {      //always draw carrots
    carrots[j].draw();
  }
}

void checkLevels() {
  if (showWin&&!endGame) {        //if level completed
    fill(255);
    if (perfect) shape(text_perfect, width/2, height/2);  //if the rabbit wasn't hit during level
    else shape(text_level_completed, width/2, height/2);
  }
  else if (showWin&&endGame) {      //if end game with victory
    textFont(font);
    fill(255);
    shape(text_youwon, width/2, height/2);
    printResults(width/2-fontScoreDim*2, height/3*2);
    printFinalResult(width/2, height/3*2+fontScoreDim*3);
    gun.init();
    rabbitOn=0;
  }
}

boolean allEaten(Carrots[] c) {
  boolean res=false;  
  for (int i=0;i<c.length;i++) {
    if (!c[i].eaten) {
      i=c.length;  
      res=false;
    }    //if there's at least one FALSE break the loop and return false
    else res=true;
  }  
  return res;
}

void newCarrots() {            //creates new unvisible carrots
  carrots = new Carrots[nCarrots];
  for (int i=0;i<nCarrots;i++) {
    carrots[i] = new Carrots(carrot, i);
  }
}

void wait4End() {
  t1 = new TimerThread(threadWaitWin, "t");
  t1.start();
}

void wait4Carrots() {    //creates a new thread each time we have to wait
  t = new TimerThread(threadWait, "t");
  t.start();
}

public void setCarrotsVisible() {    //called by the thread
  for (int i=0;i<nCarrots;i++) {
    carrots[i].visible=true;
  }
  showWin=false;
  endGame=false;
  t.quit();
}

void rabbitAlive() {
  dead=false;
  gun=new Gun(gunImg, bullet, shootRate);

  gunCurrent=millis();
  allEaten.trigger();
  newCarrots();
  wait4Carrots();
}

void printResults(int x, int y) {
  textFont(font);
  fill(#EB6D1D);
  for (int i=0;i<results.length;i++) {
    float centrate = results.length*fontScoreDim;
    text((i+1)+"\n"+results[i], x+fontScoreDim*2*i, y);
  }
}

void printFinalResult(int x, int y) {
  int res=0;
  for (int i=0;i<results.length;i++) {
    res+=results[i];
  }
  textFont(fontResult);

  if (res/results.length==100) {
    
    text_perfect_game.disableStyle();
    fill(random(255), random(255), random(255));
    noStroke();
    shape(text_perfect_game, x, y);
  }
  else { 
    fill(random(255), random(255), random(255));
    noStroke();
    rect(x-fontResultDim, y, fontResultDim*2, fontResultDim);         
    fill(random(255), random(255), random(255));
    text(res/results.length, x, y+fontResultDim-fontResultDim/20*3);
  }
  textFont(font);
}