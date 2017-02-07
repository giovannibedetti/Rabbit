public void keyPressed() {
  if (key=='s') saveFrame("theRabbitGame-####.png");    //save a screenshot
  if (key=='c') {
    if (debugOn)
      for (int i=0;i<nCarrots;i++) {            //eat all carrots
        carrots[i].eaten=true;
      }
  }
  if (key=='k') {      //kills rabbit
    if (debugOn) { 
      dead=true;
      current=millis();
    }
  }
  if (key=='g') if (debugOn) if (rabbitOn>=rabbitOnWait) rabbitOn=0; 
  else rabbitOn=rabbitOnWait;
  if (key=='d') if (debugOn) debugOn=false; 
  else debugOn = true;
  if (key=='1') if (thresh>=0) thresh--;
  if (key=='2') if (thresh<=255) thresh++;
  if (key=='3') if (bright>=-128) bright--;
  if (key=='4') if (bright<=128) bright++;
  if (key=='5') if (contrast>=-128) contrast--;
  if (key=='6') if (contrast<=128)  contrast++;
  if (key=='e') {         //force game end
    if (debugOn) { 
      endGame=true; 
      showWin=true;
    }
  }
}