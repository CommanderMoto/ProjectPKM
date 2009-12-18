class Temposweep
{
  int step=6;
  int startingX;
  float buttonSize, buttonSpacing;
  int buttonMargin;
  int maxDark = 40;
  HashMap buttonsByRow;

  Temposweep(float _buttonSize,  float _buttonSpacing, HashMap _buttonsByRow){
    buttonSize = _buttonSize;
    buttonSpacing = _buttonSpacing;
    startingX = int(_buttonSpacing);
    buttonMargin = round((buttonSpacing-buttonSize));
    buttonsByRow = _buttonsByRow;
  }

  void draw() {

    for(int i = 1; i <= 16; i++) {
      int follow = step - i;
      if (follow < 1) {
        follow += 16;
      }
      if(follow < 8) {

        fill(0, follow * (maxDark/8)+10);
      } 
      else {
        fill(0,maxDark+10);

      }
      if(step != i) {
        rect((startingX)*i, 2, buttonSpacing, height);
      }
    }


    // use a for loop to iterate over buttonsByRow (for the current step) and call some
    // method for "be active now!".
    // also, call the previous set of buttonsByRow and tell it
    // "don't be active now!"

  }

  void setValue(int _value){
    step = _value;

    //clearly this is wrong... doesn't work at all.  

    int follow = step - 1;
    if (follow < 1) {
      follow += 16;
    }

    Button[] stepButtons;
    stepButtons = (Button[]) buttonsByRow.get(step);

    Button[] followButtons;
    followButtons = (Button[]) buttonsByRow.get(follow);

    if (buttonsByRow.containsKey(step)) {
      println(step);
      for (int j =1; j<stepButtons.length; j++) {
        stepButtons[j].activeButton();
      }
      //println (thisRowButtons.length);
    }

    if (buttonsByRow.containsKey(follow)){
      println(follow);
      for (int j =1; j<followButtons.length; j++) {
        followButtons[j].inactiveButton();
      }
    }


  }
}
























