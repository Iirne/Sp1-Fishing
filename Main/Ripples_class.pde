class Ripple {
  //position values
  float posX;
  float posY;
  //size of the ripple created
  float diameter;
  //visibility is the time it takes to disappear
  //it it also used to change transparency
  float visibility = 50;

  //constructor
  Ripple(float tempPosX, float tempPosY, float tempSize) {
    posX = tempPosX;
    posY = tempPosY;
    diameter = tempSize;
  }
  
  //used to update the ripple
  void drawRipple() {
    strokeWeight(5);
    stroke(255, 255, 255, visibility*2);
    fill (0, 0, 0, 0);
    circle(posX, posY, diameter);
    visibility = visibility-1;
    diameter = diameter*1.02;
  }
}
