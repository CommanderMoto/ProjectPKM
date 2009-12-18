/**
 * Project PKM Display Layer
 * Recieves osc from Max patch, displays it in a 16:9 window. 
 * Meant to go directly on tv screen eventually.
 */

/* Osc business */
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

/* Button Array for buttoning also tempo objects maybe more*/
HashMap objectMapOSC = new HashMap();
Button[] buttons;
Temposweep temposweep;
HashMap typeMapOSC = new HashMap();

HashMap buttonsByRow = new HashMap();

/* Sets an initial Hue for colors to cycle from. Changes almost immediately */
int masterHue = 1;

void setup() {
  size(852,480); // 16:9 window
  
  
  

  /* dunno why there's a framerate specified, there usually isn't, 
   * but all the osc examples had one. */
  frameRate(30); 

  /* changing color mode to hsb for ease of getting at the color wheel. */
  colorMode(HSB, 100); 


  /* start oscP5, listening for incoming messages at port 8001
   * this isn't the port from touchosc, it's a port out of max.
   * max needs to  be set up to send out to this patch with a 
   * port different from the listen port for the controllers
   * if you're running it on the same machine. */
  oscP5 = new OscP5(this,8001);


  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. Currently not used at all. 
   * Probably should route to Max rather than direct to controller.
   */
  myRemoteLocation = new NetAddress("192.168.1.138",9000);

  /* Set the total number of button objects here. 
   * total per layer by number of layers */
  buttons = new Button[160*3];

  int buttonCounter = 0;
  int buttonSize = height/11; // size of button based on real estate
  int buttonSpacing = buttonSize+4; // spacing btwn buttons based on buttonSize

  int panelWidth = 16;
  int panelHeight = 10;

  /* sets up array and defines which osc messages apply to which panel */
  for(int i = 1; i <= panelWidth; i++){ // set
    Button[] thisRowButtons;
    thisRowButtons = new Button[panelHeight + 1];
    for(int j = 1; j <= panelHeight; j++){
      Button thisButton;

      /* panel 1 */
      thisButton = new Button(
      buttonSpacing*i, // button X
      (buttonSpacing*j)-((buttonSize)), //button Y
      buttonSize, // button length
      1 //button panel #
      ); 
      objectMapOSC.put ("/1/multitoggle1/"+(11-j)+"/"+i,   thisButton); //put current button into hashmap of all buttons from osc
      typeMapOSC.put ("/1/multitoggle1/"+(11-j)+"/"+i, "button");
      buttons[buttonCounter] = thisButton; // put current button into array of stored buttons
      buttonCounter++;

      /* panel 2 */
      thisButton = new Button(
      buttonSpacing*i,
      (buttonSpacing*j)-((buttonSize)),
      buttonSize,
      2
        );
      objectMapOSC.put ("/2/multitoggle1/"+(11-j)+"/"+i, thisButton); //put current button into hashmap of all buttons from osc
      typeMapOSC.put ("/2/multitoggle1/"+(11-j)+"/"+i, "button");
      thisRowButtons[j] = thisButton;
      buttons[buttonCounter] = thisButton; // put current button into array of stored buttons
      buttonCounter++;

      /* panel 3 */
      thisButton = new Button(
      buttonSpacing*i,
      buttonSpacing*j-((buttonSize)),
      buttonSize,
      3
        );
      objectMapOSC.put ("/3/multitoggle1/"+(11-j)+"/"+i, thisButton); //put current button into hashmap of all buttons from osc
      typeMapOSC.put ("/3/multitoggle1/"+(11-j)+"/"+i, "button");
      buttons[buttonCounter] = thisButton; // put current button into array of stored buttons
      buttonCounter++;
    }
    buttonsByRow.put(i, thisRowButtons);
  }

  temposweep = new Temposweep(buttonSize, buttonSpacing, buttonsByRow);
  objectMapOSC.put ("/temposlider/step", temposweep);
  typeMapOSC.put ("/temposlider/step", "temposweep");


}


int curSecond = 0;

void draw() {

  background (0);
  for(int i = 0; i < buttons.length; i++){
    buttons[i].draw();
    buttons[i].setHue(masterHue);
  }


  if(second() % 5 == 0 && second() != curSecond){ //does changing the modulo here make color cycle faster or slower?
    masterHue+=1;
    if(masterHue > 100){
      masterHue -=100; 
    }
    curSecond = second();
  }
  
  temposweep.draw();
  
  
 
  

}



void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */

  if(! objectMapOSC.containsKey(theOscMessage.addrPattern())){
    return;
  }


  /* check if the typetag is the right one. */
  if(theOscMessage.checkTypetag("f")) {
    float firstValue =0;
    /* parse theOscMessage and extract the values from the osc message arguments. */
    //  println(theOscMessage);
    //theOscMessage.print();
    firstValue = theOscMessage.get(0).floatValue();  
    // print("### received an osc message /test with typetag ifs.");


    if(typeMapOSC.get(theOscMessage.addrPattern())=="button") {
      Button thisOSCObject = (Button) objectMapOSC.get(theOscMessage.addrPattern());
      thisOSCObject.setValue(int(firstValue));
    } 
    else if (typeMapOSC.get(theOscMessage.addrPattern())=="temposweep") {
      Temposweep thisOSCObject = (Temposweep) objectMapOSC.get(theOscMessage.addrPattern());
      thisOSCObject.setValue(int(firstValue));
    }
  } 
  else if(theOscMessage.checkTypetag("i")) {
    int firstValue =0;
    /* parse theOscMessage and extract the values from the osc message arguments. */
    //  println(theOscMessage);
    //theOscMessage.print();
    firstValue = theOscMessage.get(0).intValue();  
    // print("### received an osc message /test with typetag ifs.");


    if(typeMapOSC.get(theOscMessage.addrPattern())=="button") {
      Button thisOSCObject = (Button) objectMapOSC.get(theOscMessage.addrPattern());
      thisOSCObject.setValue(firstValue);
    } 
    else if (typeMapOSC.get(theOscMessage.addrPattern())=="temposweep") {
      Temposweep thisOSCObject = (Temposweep) objectMapOSC.get(theOscMessage.addrPattern());
      thisOSCObject.setValue(firstValue);
    }
  }
  //println("### received an osc message. with address pattern "+theOscMessage.addrPattern());




}

void mousePressed() {

}















