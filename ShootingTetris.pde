import java.util.Iterator;

int h;
int w;

int level, score;

long time;

ArrayList<Block> blockList;

void setup() {
  orientation(PORTRAIT);
  background(0);
  h = displayHeight;
  w = displayWidth;
  score=0;
  level=1;
  blockList = new ArrayList<Block>();
  time = millis();
  isFull=false;
}

void draw() {
  fill(255, 255, 255);
  if (millis()-time >1000 && !isFull) {
    blockList.add(new Block(level++));
    time=millis();
  }  
  background(0);
  stroke(57, 255, 20);
  line(w/2, 0, w/2, 3*h/4);
  line(0, 3*h/4, w, 3*h/4);
  for (Block block : blockList)
    block.drawBlock();
  if (isFull) {
    //clear();
    //background(255);
    textAlign(CENTER, CENTER);
    textSize(80);
    fill(0, 102, 153);
    text("Game Over", w/2, h/2);
    //return;
  }
}

void mousePressed() {
  //background(0);
  boolean isPopped = false;
  Iterator<Block> iter = blockList.iterator();
  while (iter.hasNext ()) {
    Block b = iter.next();
    if (b.containsPoint(mouseX, mouseY)) {
      iter.remove();
      isPopped = true;
      break;
    }
  }
  if (isPopped) {
    iter = blockList.iterator();
    while (iter.hasNext ()) {
      Block b = iter.next();
      b.unsetBottom(mouseX, mouseY);
    }
  }
}
