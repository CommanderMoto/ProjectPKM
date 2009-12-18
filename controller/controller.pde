import oscP5.*;
import netP5.*;

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
MatrixButton [][][] buttonGrid;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

void setup() {
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(1);
  buttonGrid = new MatrixButton[numPanels][panelWidth][panelHeight];
  for (int panelNumber = 0; panelNumber < numPanels; panelNumber++) {
    for(int row = 0; row < panelHeight; row++){
      for (int column = 0; column < panelWidth; column++) {
        MatrixButton foo = new MatrixButton(panelNumber, row, column, oscP5);
        buttonGrid[panelNumber][column][row] = foo;
        oscP5.plug(foo, "setState", foo.touchOSCAddress());
      }
    }
  }
}

void draw() {
  MatrixButton[] row = buttonGrid[0][currentRow];
  println("Row: "+row[0].to_s()+","+row[1].to_s()+","+row[2].to_s()+","+row[3].to_s()+","+row[4].to_s()+","+row[5].to_s()+","+row[6].to_s()+","+row[7].to_s()+","+row[8].to_s()+","+row[9].to_s());
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
