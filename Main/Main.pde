ArrayList<Fish> fishes = new ArrayList<Fish>();
boolean[] inputs = new boolean[5];
Boat boat = new Boat(height/2, width/2);

void setup() {
  size(800, 800);
}

void draw() {
  //resets per frame
  background(#00C7FF);
  //adds a new fish every 30 frame
  if (frameCount % 30 == 0) {
    //fisk skallerings konstant
    float extraRandom = random(0.25, 1);
    fishes.add(new Fish(random(0, width), 10, random(2, 6)*extraRandom, extraRandom*random(1, 4), 2*-((0-extraRandom*random(1, 2)))));
  }
  //update fish logic
  for (int i = 0; i < fishes.size(); i++) {
    //gets the fish to be updated
    Fish tempFish = fishes.get(i);

    //removes a fish if off-screen
    if (tempFish.fishGone() || (tempFish.isCaught && boat.lineOnHold)) {
      fishes.remove(i);
    }
    //whille it could be within the fish class, as it is setup it allows for easier scaling of the amount of boats
    if (boat.landed) {
      tempFish.fishLineBehaviour(boat.fLPosX, boat.fLPosY, frameCount-boat.frameskip);
    }
    //updates movement
    tempFish.moveFish();

    //draws the fish
    tempFish.drawFish();


    //to make catching prettier
    if (tempFish.isCaught && frameCount % 4 == 0) {
      boat.ripples.add(new Ripple((int)(boat.fLPosX+random(-5*tempFish.fishSize, 5*tempFish.fishSize)), (int)(boat.fLPosY+random(-5*tempFish.fishSize, 5*tempFish.fishSize)), tempFish.fishLength*5));
    }
  }



  //water logic, ripples and such
  boat.updateRipples();

  //update boat
  boat.boatRotate(0);
  boat.moveBoat();
  boat.drawBoat();

  //fishing line logic boat side of it
  boat.updateLine();
  boat.throwLine((float)mouseX-boat.mouseXPrevious, (float)mouseY-boat.mouseYPrevious);
  boat.drawLine();
}

//from here on is input hell
//where input is managed
//it is stupid but working

//for when mouse is pressed (any button)
void mousePressed() {
  //used for the fishing line
  inputs[3] = true;
}

//for when mouse is released (any button)
void mouseReleased() {
  //used for the fishing line
  inputs[3] = false;
}

//for when you press any keyboard key
void keyReleased() {
  //key is set by keypressed as the 'char' of what was pressed
  switch(key) {
  case 'D':
  case 'd':
    //used to rotate right
    inputs[0] = false;
    break;
  case 'A':
  case 'a':
    //used to rotate left
    inputs[1] = false;
    break;
  case 'W':
  case 'w':
    //used to move forward
    inputs[2] = false;
    break;
  }
}

//for when you release any keyboard key
void keyPressed() {
  //key is set by keypressed as the 'char' of what was pressed
  switch(key) {
  case 'D':
  case 'd':
    //used to rotate right
    inputs[0] = true;

    break;
  case 'A':
  case 'a':
    //used to rotate left
    inputs[1] = true;
    break;
  case 'W':
  case 'w':
    //used to move forward
    inputs[2] = true;
    break;
  }
}
