class Button
{
  float x,y, sqLength;
  float sqWidth, sqXPos;
  int sqHue = 100;
  int sqBright = 100;
  int sqAlphaDefault = 30;
  int sqAlpha = sqAlphaDefault;
  int identity;
  boolean setPressed;
  boolean setActive;


  /* SVG getter business */
  PShape left;
  PShape right;
  PShape middle;
  PShape middleOn;
  PShape fullButton;
  PShape fullButtonActive, middleOnActive, middleActive, rightActive, leftActive;

  Button(float _x, float _y, float _sqLength, int _identity){
    x=_x;
    y=_y;
    sqLength=_sqLength;
    identity=_identity;
    float scaleFactor, scaleFactorActive;

    /*set up svg layers as objects*/
    fullButton = loadShape("button3.svg");
    scaleFactor = (sqLength/fullButton.width);
    middleOn = fullButton.getChild("middleOn");
    middleOn.scale(scaleFactor);
    left = fullButton.getChild("left");
    left.scale(scaleFactor);
    right = fullButton.getChild("right");
    right.scale(scaleFactor);
    middle = fullButton.getChild("middle");
    middle.scale(scaleFactor);

    fullButtonActive = loadShape("button3.svg");
    scaleFactorActive = ((sqLength/fullButtonActive.width)+.2);
    middleOnActive = fullButtonActive.getChild("middleOn");
    middleOnActive.scale(scaleFactorActive);
    leftActive = fullButtonActive.getChild("left");
    leftActive.scale(scaleFactorActive);
    rightActive = fullButtonActive.getChild("right");
    rightActive.scale(scaleFactorActive);
    middleActive = fullButtonActive.getChild("middle");
    middleActive.scale(scaleFactorActive);

    smooth();

  }

  void setHue(int _newHue){
    sqHue = _newHue;
  }


  void draw(){
    noStroke();
    int thisHue = sqHue + 33*identity - 1;
    if(thisHue > 100) {
      thisHue -= 100;
    }

    switch(identity){
    case 1:
      if(setPressed==true){
        left.disableStyle();
        noStroke();
        fill(thisHue,100,sqBright,sqAlpha);
        shape(left,x,y);
      }
      break;
    case 2:
      middle.disableStyle();
      noStroke();
      fill(thisHue,50,sqBright,sqAlpha);
      shape(middle,x,y);
      if(setPressed==true){
        if(setActive) {
          middleOnActive.disableStyle();
          noStroke();
          fill(thisHue+5,100,sqBright,sqAlpha-30);
          shape(middleOnActive,x-10,y-10);
        }
        else {
          middleOn.disableStyle();
          noStroke();
          fill(thisHue,100,sqBright,sqAlpha);
          shape(middleOn,x,y);
        }

      }
      break;
    case 3:
      if(setPressed==true){
        right.disableStyle();
        noStroke();
        fill(thisHue,100,sqBright,sqAlpha);
        shape(right,x,y);
      }
      break;
    }


  }

  void setValue( int _value) {
    sqAlpha = (100-sqAlphaDefault)*_value+sqAlphaDefault;
    if (_value==1) {
      setPressed = true;
    }
    else {
      setPressed = false;
    }
  }

  void activeButton() {
    //sqHue = sqHue+10;
    setActive = true;

  }
  void inactiveButton() {
    //sqHue = sqHue-10;
    setActive = false;
  }


}
















