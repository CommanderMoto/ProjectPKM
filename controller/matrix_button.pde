class MatrixButton {
  int panel, row, column, state;
  OscP5 theOSC;
  MatrixButton(int _panel, int _row, int _column, OscP5 _osc) {
    panel = _panel;
    row = _row;
    column = _column;
    theOSC = _osc;
    state = 0;
  }
  
  /*public void setState(int theA) {
    println("Hey, "+panel+"/"+row+"/"+column+" new state = "+theA);
    state = theA;
  }*/
  
  public void setState(float theA) {
    println("Hey, "+panel+"/"+row+"/"+column+" new state = "+theA);
    state = (int) theA;
  }
  
  int getState() {
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
  
  String touchOSCAddress() {
    return  "/"+(panel + 1)+"/multitoggle1/"+(panelHeight - row)+"/"+(column + 1);
  }
  
  String to_s()
  {
    return ""+state;
  }
}

