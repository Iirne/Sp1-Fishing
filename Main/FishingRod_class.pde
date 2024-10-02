class Boat {

  //fishing line variables
  float fLPosX = 0;
  float fLPosY = 0;
  int fLPosZ = 0;
  float fLDirX;
  float fLDirY;
  //for throwing fishing line
  int mouseXPrevious;
  int mouseYPrevious;
  //for ripples on fishing line
  boolean landed = false;
  int frameskip;
  boolean lineOnHold = true;
  boolean caughtFish = false;

  //the boats movement values
  float posX;
  float posY;
  float dirX;
  float dirY = 1;
  float speed = 3;

  //for visuals
  float rotationSpeed = 2;
  float rotation;
  float sumRotation;

  //boats manages ripples of their own creation.
  //in case the boat got deleted this would be bad
  ArrayList<Ripple> ripples = new ArrayList<Ripple>();

  //constructor
  Boat(float tempPosX, float tempPosY) {
    posX = tempPosX;
    posY = tempPosY;
  }
  //updates the boat position based on input
  void moveBoat() {
    if (inputs[2] ) {
      posX += dirX * speed;
      posY += dirY * speed;
      ripples.add(new Ripple((int)(posX), (int)(posY), 30));
    }
  }
  //rotates the boat based on input
  void boatRotate(float TempRotate) {
    rotation = TempRotate;
    if (inputs[2]) {
      if (inputs[0]) {
        rotation += rotationSpeed;
        ripples.add(new Ripple((int)(posX + dirX*65), (int)(posY + dirY*65), 20));
      }
      if (inputs[1]) {
        rotation += -rotationSpeed;
        ripples.add(new Ripple((int)(posX + dirX*65), (int)(posY + dirY*65), 20));
      }
    }
    
    
    float cos = cos(radians(rotation));
    float sin = sin(radians(rotation));
    float tempX = dirX * cos - dirY * sin;
    dirY = dirX * sin + dirY * cos;
    dirX = tempX;
    
  }

  //the graphical elemtents of the boat
  void drawBoat() {
    
    noStroke();
    translate(posX, posY);
    //rotates boat to sum of its rotations
    sumRotation += rotation;
    rotate(radians(sumRotation));
    fill(0);
    rect(15, 0+30, -30, -40);
    ellipse(0, 0+30, 30, 80);
    rotate(radians(-sumRotation));
    translate(-posX, -posY);
  }
  void throwLine(float tempDirX, float tempDirY) {

    if (inputs[3] && lineOnHold == true) {
      lineOnHold = false;
      fLPosX = posX;
      fLPosY = posY;
      fLPosZ = 100;
      fLDirX = tempDirX/20;
      fLDirY = tempDirY/20;
    } else if (inputs[3] && landed == true) {
      fLPosX = posX*0.01 + fLPosX*0.99;
      fLPosY = posY*0.01 + fLPosY*0.99;
    }
    mouseXPrevious = mouseX;
    mouseYPrevious = mouseY;
  }

  void updateLine() {
    fLPosX += fLDirX;
    fLPosY += fLDirY;
    if ((fLPosX-posX)*(fLPosX-posX)+(fLPosY-posY)*(fLPosY-posY)<=625 && landed) {
      println("update");
      lineOnHold = true;
      landed = false;
      inputs[3] = false;
      caughtFish = false;
    }

    if (lineOnHold == false) {
      if (fLPosZ < 0) {
        if (landed == false) {
          frameskip = frameCount;
          landed = true;
        }
        if ((frameCount-frameskip)%60 == 0 && landed == true) {
          ripples.add(new Ripple((int)(fLPosX), (int)(fLPosY), 20));
        }
        fLDirX = fLDirX * 0.8;
        fLDirY = fLDirY * 0.8;
      } else {
        fLPosZ--;
        fLDirX = fLDirX * 0.99;
        fLDirY = fLDirY * 0.99;
      }
    }
  }
  void drawLine() {
    if (lineOnHold == false) {
      strokeWeight(5);
      stroke(255);
      line(posX, posY, fLPosX, fLPosY);
    }
  }


  void updateRipples() {
    //for each can probably be used, but i don't know a method which allows deletion
    for (int i = 0; i < ripples.size(); i++) {
      Ripple tempRipples = ripples.get(i);
      //deletes ripples too small
      if (tempRipples.diameter < 0 || tempRipples.visibility < 0) {
        ripples.remove(i);
      }
      //drawing ripples;
      tempRipples.drawRipple();
    }
  }
}
