class MatrixButton {
  int panel, row, column, note;
  float state;
  OscP5 osc;
  NetAddressList clients;
  MatrixButton(int _panel, int _row, int _column, int _note, OscP5 _osc, NetAddressList _clients) {
    panel = _panel;
    row = _row;
    column = _column;
    note = _note;
    osc = _osc;
    clients = _clients;
    state = 0;
  }
  
  public void setState(int theA) {
    state = (float) theA;
  }
  
  public void setState(float theA) {
    //println("Hey, "+panel+"/"+row+"/"+column+" new state = "+theA);
    state = theA;
    if (theA <= 1.0) {
      OscMessage mirrorMessage = new OscMessage(this.touchOSCAddress());
      mirrorMessage.add(this.getState());
      osc.send(mirrorMessage, clients);
    }
  }
  
  float getState() {
    return state;
  }
  
  int getRow() {
    return row;
  }
  
  int getPanel() {
    return panel;
  }
  
  int getColumn() {
    return column;
  }
  
  int getNote() {
    return note;
  }
  
  String touchOSCAddress() {
    return  "/"+(panel + 1)+"/multitoggle1/"+(panelHeight - row)+"/"+(column + 1);
  }
  
  void addToBundle(OscBundle theBundle, OscMessage theMessage)
  {
    theMessage.clear();
    theMessage.setAddrPattern(this.touchOSCAddress());
    theMessage.add(this.getState());
    theBundle.add(theMessage);
  }
  
  String to_s()
  {
    return ""+state;
  }
}

