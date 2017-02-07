public class TimerThread extends Thread {

  boolean running;           
  int wait;                
  String id;             
  int count;             

  public TimerThread (int w, String s) {
    wait = w;
    running = false;
    id = s;
    count = 0;
  }

  public int getCount() {
    return count;
  }

  public void start () {
    running = true;
    try {
      super.start();
    }
    catch(java.lang.IllegalThreadStateException itse) {
    }
  }

  public void run () {
    while (running && count < 1) {
      count++;
      // Ok, let's wait for however long we should wait
      try {
        sleep((long)(wait));
      } 
      catch (Exception e) {
      }
    }
    perfect=false;            //stop showing perfect text
    if (endGame) {
      gun.init();
      gunCurrent=millis();
      rabbitOn=0;
      winCount=0;                    //this starts all again
      results = new int[levels];
      endGame=false;
    }
    winCount++;            //goes to the next level
    setCarrotsVisible();
    // The thread is done when we get to the end of run()
  }

  public void quit() {
    running = false;  // Setting running to false ends the loop in run()
    // In case the thread is waiting. . .
    interrupt();
  }
}