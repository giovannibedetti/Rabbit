import ddf.minim.*;
Minim minim;
int saDim = nCarrots;
int eaDim = nCarrots;
int nSamples=6;
int nEaten=5;
AudioSample[] sampleArray; 
AudioSample[] eatenArray;
AudioSample allEaten;
AudioSample allEatenFx;
AudioSample drinking;
AudioPlayer battle;
AudioSample oh;
AudioSample splut;
AudioSample rabbit_death;
AudioSample rabbit_win;

public void minimSetup() {
  minim=new Minim(this);
  //  minim.debugOn();
  loadSamples();
}

public void loadSamples() {
  sampleArray= new AudioSample[nSamples];
  eatenArray = new AudioSample[nEaten];
  for (int i = 0; i < sampleArray.length; i++) {
    sampleArray[i] = minim.loadSample(i + ".aif");    //i have 6 aif samples
  }
  for (int i = 0; i < eatenArray.length; i++) {
    eatenArray[i] = minim.loadSample("eaten_"+i+ ".aif");  //i have 5 aif samples
  }
  allEaten = minim.loadSample("eaten_all.aif");
  allEatenFx = minim.loadSample("cartoon_accent.aif");
  drinking = minim.loadSample("drinking_all.aif");
  battle = minim.loadFile("gun_theme.aif");
  oh = minim.loadSample("oh!.aif");
  splut = minim.loadSample("splut.aif");
  rabbit_death = minim.loadSample("rabbit_death.aif");
  rabbit_win = minim.loadSample("rabbit_win.aif");
}

void minimStop() {
  minim.stop();
  super.stop();
}