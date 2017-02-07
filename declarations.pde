import gab.opencv.*;
import java.awt.Rectangle;
import de.looksgood.ani.*;
import processing.video.*;


boolean debugOn=false;
Capture video;
OpenCV opencv;

int levels=5;

//rabbit images
int nCuts = 5;
int nFramesL = 5*nCuts;
int nFramesR = 5*nCuts;
PImage[] framesL = new PImage[nFramesL];
PImage[] framesR = new PImage[nFramesR];

PImage bg;

//PShape bg;

PShape carrot;
PImage bottomImage;
PShape[] carrotLife = new PShape[nCuts];
PShape text_perfect, text_perfect_game, text_level_completed;
PShape text_youwon;
PShape[] text_level = new PShape[levels];
PShape text_loser;
int captureW = 320;
int captureH = 240;

float wScaler = 0.6;
int animSpeed = 10;  // every x pixels is shown a different image


int[] results = new int[levels];
int defaultCarrots=5;
int nCarrots = defaultCarrots;
int nEatenCarrots = 0;
Carrots[] carrots;

TimerThread t;              //thread to make carrots visible
TimerThread t1;            //thread for victory
int threadWait=5000;
int threadWaitWin=15000;
int thresh = 0;
int bright = 0;
int contrast = 0;

Gun gun;
PImage gunImg;
PShape bullet;
int shootRate=2000;
int yPos;      //used to follow rabbit with gun
int current;  //time passes by
boolean dead;
boolean showWin=false;
int winCount=0;
boolean endGame;
int gunCurrent;
int rabbitOn;
int rabbitOnWait=200;
boolean perfect=false;

int timeForComeBack = 20000;        //coming back from the dead
CarrotJuice carrotJuice;
boolean drinkingTriggered=false;

int fontScoreDim=36;
int fontResultDim=50;
PFont font;
PFont fontResult;