private static int[] heightJams = {
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0
}; 

private static boolean[] colFilled = {
  false, false, false, false, false, false, false, false, false, false
};

public static boolean isFull;

class Block { 
  private final int laneSize = displayWidth/10;

  private boolean atBottom=false;
  private int velocity, 
  blockHeight, 
  blockWidth, 
  bottomLeftY, 
  leftLane, 
  hp, 
  finalY, 
  level;
  private long time;
  private int[] prevHeightJam = {
    0, 0, 0, 0
  };

  Block(int level) {
    this.level=level;
    velocity = 2*int(random(1, level)* laneSize);
    hp = int(random(1, level));
    blockHeight = int(random(min(max(floor((12-level)/3), 1), 3), 3));
    int iter=0;
    int i;
    boolean isSet=false;
    for (i=0; i<10; i++)
      if ( !colFilled[i])
        break;
    if (i==10) {
      isFull=true;
      isSet=true;
      blockWidth=1;
      leftLane=0;
      isSet=true;
    }
    while (!isSet) {
      isSet=true;
      blockWidth = int(random(min(max(floor((12-level)/3), 1), 3), 3));
      leftLane=int(random(0, 10- blockWidth+1));
      for (i= leftLane; i< leftLane + blockWidth; i++)
        if (colFilled[i]) {
          isSet = false;
          break;
        }
    }
    time = millis();
  }

  void drawBlock() {
    int i, distFromBottom=0;
    if (!atBottom) {
      for (i= leftLane; i< leftLane+ blockWidth; i++)
        distFromBottom = max( distFromBottom, heightJams[i]);
      distFromBottom*= laneSize;
      if (int(velocity*(millis()-time)/1000)+ blockHeight * laneSize > displayHeight - distFromBottom* laneSize ) {
        finalY = displayHeight- distFromBottom -blockHeight*laneSize;
        rect( leftLane* laneSize, finalY, blockWidth* laneSize, blockHeight * laneSize);
        // if (!atBottom) {
        atBottom = true;
        int tempHeight=0;
        for (i= leftLane; i< leftLane + blockWidth; i++) {
          prevHeightJam[i-leftLane] = heightJams[i];
          tempHeight= max( heightJams[i] + blockHeight, tempHeight);
        }
        for (i= leftLane; i< leftLane + blockWidth; i++)
          heightJams[i] = tempHeight;

        if ( finalY < 0)
          for (i= leftLane; i< leftLane + blockWidth; i++)
            colFilled[i] = true;


        //   }
      } else
        rect( leftLane* laneSize, int(velocity*(millis()-time)/1000), blockWidth* laneSize, blockHeight * laneSize);
    } else
      rect( leftLane* laneSize, finalY, blockWidth* laneSize, blockHeight * laneSize);
  }

  boolean containsPoint(int x, int y) {
    if (atBottom) {
      if (x>= leftLane* laneSize && x<= (leftLane + blockWidth)* laneSize && y>= finalY&& y<= finalY+blockHeight * laneSize) {
        int i;
        for (i= leftLane; i< leftLane + blockWidth; i++) {
          heightJams[i] = min(prevHeightJam[i-leftLane],heightJams[i]);
          colFilled[i] = false;
        }
        return true;
      }
    } else {
      // Variable storing current y. Any resemblance to an Indian food item is purely coincidental.
      int currY= int(velocity*(millis()-time)/1000);
      if ( x>= leftLane* laneSize && x<= leftLane* laneSize+ blockWidth* laneSize && y>= currY && y<= currY +blockHeight * laneSize )
        return true;
    }
    return false;
  }

  void unsetBottom(int x, int y) {
    if (atBottom) {
      if (leftLane* laneSize < x && (leftLane+blockWidth)* laneSize > x && y>= finalY) {
        atBottom = false;
        //time = millis();
        // TODO: Figure out how to handle the timing- probably note final 
        // time and take a difference it something

        // TODO: Figure out when to push a block down
        int i;
        for (i= leftLane; i< leftLane + blockWidth; i++) {
          colFilled[i] = false;
          heightJams[i] = prevHeightJam[i-leftLane];
          //TODO: Something's very wrong with heightJams[] adjustment. Find out what.
        }
      }
    }
  }
}
