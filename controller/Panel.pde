import oscP5.*;
import netP5.*;
import themidibus.*;

class Panel {
  int pWidth, pHeight, id;
  OscP5 osc;
  MidiBus midiBus;
  NetAddressList clients;
  V2Button[][] buttonGrid;

  Panel(int anId, int aWidth, int aHeight, OscP5 anOsc, MidiBus aMidiBus, NetAddressList someClients) {
    id = anId;
    pWidth = aWidth;
    pHeight = aHeight;
    osc = anOsc;
    midiBus = aMidiBus;
    clients = someClients;
    buttonGrid = new V2Button[pWidth][pHeight];
    for(int row = 0; row < panelHeight; row++){
      for (int column = 0; column < panelWidth; column++) {
        V2Button foo = new V2Button(row, column, this);
        buttonGrid[column][row] = foo;
        oscP5.plug(foo, "setState", foo.touchOSCAddress(id));
      }
    }
  }
  
  String oscAddressForButton(V2Button theButton) {
    return "/"+id+"/"+theButton.oscAddress();
  }
  
  void buttonStateUpdated(V2Button theButton, float newState) {
    OscMessage mirrorMessage = new OscMessage(this.oscAddressForButton(theButton));
    mirrorMessage.add(newState);
    osc.send(mirrorMessage, clients);
  }
}


