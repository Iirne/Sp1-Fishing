class Ripple {
  float posX;
  float posY;
  float diameter;
  float visibility = 50;

  Ripple(float tempPosX, float tempPosY, float tempSize) {
    posX = tempPosX;
    posY = tempPosY;
    diameter = tempSize;
  }


  void drawRipple() {
    strokeWeight(5);
    stroke(255, 255, 255, visibility*2);
    fill (0, 0, 0, 0);
    circle(posX, posY, diameter);
    visibility = visibility-1;
    diameter = diameter*1.02;
  }
}
