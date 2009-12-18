import oscP5.*;
import netP5.*;
import themidibus.*;

MidiBus myBus;
OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 8000;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 9000;

int numPanels = 3;
int panelWidth = 16;
int panelHeight = 10;
int currentRow = 0;
float bpm = 90.0;
MatrixButton [][][] buttonGrid;
int[] toneMap = {60,62,64,67,69,72,74,76,79,81};

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

void setup() {
  myBus = new MidiBus(this, 0, 0);
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(bpm / 15.0);
  buttonGrid = new MatrixButton[numPanels][panelWidth][panelHeight];
  for (int panelNumber = 0; panelNumber < numPanels; panelNumber++) {
    for(int row = 0; row < panelHeight; row++){
      for (int column = 0; column < panelWidth; column++) {
        MatrixButton foo = new MatrixButton(panelNumber, row, column, toneMap[row], oscP5, myNetAddressList);
        buttonGrid[panelNumber][column][row] = foo;
        oscP5.plug(foo, "setState", foo.touchOSCAddress());
      }
    }
  }
  oscP5.plug(this, "clearPanel1", "/4/push1");
  oscP5.plug(this, "clearPanel2", "/4/push2");
  oscP5.plug(this, "clearPanel3", "/4/push3");
  oscP5.plug(this, "sendPanel1", "/4/send1");
  oscP5.plug(this, "sendPanel2", "/4/send2");
  oscP5.plug(this, "sendPanel3", "/4/send3");
}

void draw() {
  beat();
}

void broadcastPanel(int panelNumber)
{
  OscMessage theMessage = new OscMessage("/foo");
  for (int row = 0; row < panelHeight; row++) {
    OscBundle theBundle = new OscBundle();
    for (int column = 0; column < panelWidth; column++) {
      buttonGrid[panelNumber][column][row].addToBundle(theBundle, theMessage);
    }
    oscP5.send(theBundle, myNetAddressList);
  }
}

void clearPanel1(float theA)
{
  clearPanel(0);
}

void clearPanel2(float theA)
{
  clearPanel(1);
}

void clearPanel3(float theA)
{
  clearPanel(2);
}

void sendPanel1(float theA)
{
  broadcastPanel(0);
}

void sendPanel2(float theA)
{
  broadcastPanel(1);
}

void sendPanel3(float theA)
{
  broadcastPanel(2);
}

void clearPanel(int panelNumber)
{
  for (int row = 0; row < panelHeight; row++) {
    for (int column = 0; column < panelWidth; column++) {
      buttonGrid[panelNumber][column][row].setState(0.0);
    }
  }  
  broadcastPanel(panelNumber);
}

void updatePanelSlider() {
  OscBundle myBundle = new OscBundle();
  OscMessage fader = new OscMessage("/1/fader1");
  float pos = ((float)currentRow) / 15.0;
  for (int panel = 0; panel < numPanels; panel++) {
    fader.setAddrPattern("/"+(panel+1)+"/fader1");
    fader.add(pos);
    myBundle.add(fader);
  }
  oscP5.send(myBundle, myNetAddressList);    
}

void playPanelNotes() {
  int [][] notesToKill = new int [3][panelHeight];
  for (int panel = 0; panel < numPanels; panel++) {    
    MatrixButton[] row = buttonGrid[panel][currentRow];
    for (int i = 0; i < panelHeight; i++) {
      if (row[i].getState() != 0.0) {
        notesToKill[panel][i] = 1;
        myBus.sendNoteOn(panel,row[i].note,128);
      } else {
        notesToKill[panel][i] = 0;
      }
    }
  }
  delay(200);
  for (int panel = 0; panel < numPanels; panel++) {    
     MatrixButton[] row = buttonGrid[panel][currentRow];
     for (int i = 0; i < panelHeight; i++) {
      if (notesToKill[panel][i] != 0) {
        myBus.sendNoteOff(panel,row[i].note,128);
      }
    }
  }
}

void beat() {
  updatePanelSlider();
  playPanelNotes();
  if (++currentRow >=panelWidth) {
    currentRow = 0;
  }
}

void oscEvent(OscMessage theOscMessage) {
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(myConnectPattern)) {
    connect(theOscMessage.netAddress().address());
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) {
    disconnect(theOscMessage.netAddress().address());
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddresList. 
   */
  else {
     if(theOscMessage.isPlugged()==false) {
      /* print the address pattern and the typetag of the received OscMessage */
      println("### received an osc message.");
      println("### addrpattern\t"+theOscMessage.addrPattern());
      println("### typetag\t"+theOscMessage.typetag());
    }
    oscP5.send(theOscMessage, myNetAddressList);
  }
}


 private void connect(String theIPaddress) {
     if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
       myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
       println("### adding "+theIPaddress+" to the list.");
     } else {
       println("### "+theIPaddress+" is already connected.");
     }
     println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
     /* Since we've got a newly connected client, let's get them up to date with what's already in the matrix */
     for (int i = 0; i < 3; i++) {
       broadcastPanel(i);
     }
 }



private void disconnect(String theIPaddress) {
if (myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
		myNetAddressList.remove(theIPaddress, myBroadcastPort);
       println("### removing "+theIPaddress+" from the list.");
     } else {
       println("### "+theIPaddress+" is not connected.");
     }
       println("### currently there are "+myNetAddressList.list().size());
 }
