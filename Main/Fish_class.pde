class Fish {
  //movement and positioning
  float posX;
  float posY;
  float dirX;
  float dirY = 1;
  float rotation;
  float speed = 2;
  float scaredSpeed = 1;
  boolean isCaught = false;
  //used to see how far off screen they have to be to disappear
  int oobFactor = 100;
  int appealFactor = (int)random(100, 300);

  //appearance values
  float fishSize=10;
  float fishLength= 20;
  float tailSmoothrotation;
    //only used with drawing the body
  float sumRotation;

  //constructor for fish
  Fish(float tempX, float tempY, float tempFishLength, float tempFishSize, float tempSpeed) {
    posX = tempX;
    posY = tempY;
    fishLength = tempFishLength;
    fishSize = tempFishSize;
    speed = tempSpeed;
  }


  void drawFish() {
    fill(#327AC1);
    //sets origin to fish position
    translate(posX, posY);
    //moves the origin to the tip of the head
    translate(-15*fishLength*dirX/2, -15*fishLength*dirY/2);
    //rotates the fish to the sum of its rotations
    sumRotation += rotation;
    rotate(radians(sumRotation));
    noStroke();

    //tail
    float tailRotationFactor = 4;
    tailSmoothrotation= rotation*0.3 + tailSmoothrotation*0.7;
    rotate(radians(-tailSmoothrotation*tailRotationFactor));
    ellipse(0, -4*fishLength, 10*fishSize, 20*fishLength);

    //2nd tail part
    translate(0, -7*fishLength);
    rotate(radians(-tailSmoothrotation*tailRotationFactor));
    ellipse(0, -7*fishLength, 7*fishSize, 20*fishLength);

    //counterrotations
    rotate(radians(tailSmoothrotation*tailRotationFactor));
    translate(0, 7*fishLength);
    rotate(radians(tailSmoothrotation*tailRotationFactor));



    //body
    //fins
    triangle(0, 4*fishLength, 12*fishSize, -4*fishLength, -12*fishSize, -4*fishLength);
    ellipse(0, 0, 10*fishSize, 15*fishLength);
    //counteracts rotation and translation to avoid causing issues
    rotate(radians(-sumRotation));
    translate(15*fishLength*dirX/2, 15*fishLength*dirY/2);
    translate(-posX, -posY);
  }



  void moveFish() {
    //scares fish when boat is moving
    if (inputs[2]) {
      scaredFish(boat.posX, boat.posY, 30625);
    }
    
    //for fishes reaction to the line
    //should be fed in instead of this bad thing
    
    //moves 1 step if not caught
    if (!isCaught) {
      //updates position of fish
      posX += dirX*(speed+scaredSpeed);
      posY += dirY*(speed+scaredSpeed);
      //fishes gets a speed boost shortly after getting scared that disappears
      scaredSpeed = scaredSpeed*0.99 + speed*0.01;
    }



    //rotates the direction the fish is going (negative rotation goes left, positive goes right)
    rotation = 0.7*rotation + random(-5, 5);
    float cos = cos(radians(rotation));
    float sin = sin(radians(rotation));
    float tempX = dirX * cos - dirY * sin;
    dirY = dirX * sin + dirY * cos;
    dirX = tempX;
  }



  //rotates the fish away from the point given
  void scaredFish(float X, float Y, float loudness) {
    if ((X-posX)*(X-posX) + (Y-posY)*(Y-posY) <= loudness) {
      scaredSpeed = speed;
      rotation = -13 * Math.signum(dirX*(Y-posY)-(X-posX)*dirY);
    }
  }


  //rotates the fish toward point given
  void attractFish(float X, float Y) {
    if ((X-posX)*(X-posX) + (Y-posY)*(Y-posY) <= appealFactor*appealFactor) {
      rotation = 13 * Math.signum(dirX*(Y-posY)-(X-posX)*dirY);
    }
  }
  
  
  
  void fishLineBehaviour(float localX, float localY, int Timer) {
    if (Timer <= 4) {
      scaredFish(localX, localY, 22500);
    } else if (Timer >= 70 ) {
      caughtFish(localX, localY);
      if (Timer%3 == 0) {
        if (!boat.caughtFish) {
          attractFish(localX, localY);
        } else {
          scaredFish(localX, localY, 22500);
        }
      }
    }
  }

  void caughtFish(float localX, float localY) {
    if ((posX-localX)*(posX-localX)+(posY-localY)*(posY-localY)<= 50*50) {
      isCaught = true;
      boat.caughtFish = true;
    }
    if (isCaught) {
      attractFish(localX, localY);
      posX = localX;
      posY = localY;
    }
  }


  //to see if the fish is away from the screen
  boolean fishGone() {
    if (posX < 0-oobFactor || posX > width+oobFactor || posY < 0-oobFactor || posY > height+oobFactor) {
      return(true);
    } else {
      return(false);
    }
  }
}
