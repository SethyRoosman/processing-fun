import processing.sound.*;
Amplitude amp;
AudioIn in;

int max_x = 640;
int max_y = 360;

int[] board = new int[640];

color white = color(255, 255, 255);

// going to translste value s by *640
// also need to shift values over each sensor poll
//   newHeight@index = board[x - 1]
//    w. Edge cases for index 0 & new val at index[width]
void shift() {
  int height = (int) (amp.analyze() * 360 * 10);
  board[639] = height;
  //println(height + " + " + amp.analyze());
  for (int i = 0; i < 639; i++) {
    // new measurements will be far right to left
    board[i] = board[i + 1];
    if (i % 10 == 0) {
      println(frameRate);
    }
  }
}

// TODO:
//  convert set to line for speed sake

void nudge() {
  // this function "bumps" up the surrounding pixels depending on mouse position
  
  //       X
  //  [+10x15across] (needs to be odd for mouse precise coordinate
  //  [+8x4 each side]
  //  [+4x2 each side]
  //  15 + 8 + 4 = 27 or 13 each side
  for (int a = (mouseX - 13); a < (13 + mouseX); a++) {
    if (a < 0 || a >= 640) {
      // not a valid array index
    } else {
      if (a < mouseX - 11 || a > mouseX + 11) {
        // bump up by 4
        board[a] += 4;
      } else if (a < mouseX - 7 || a > mouseX + 7) {
        // bump up by 8
        board[a] += 8;
      } else if (a < mouseX - 3 || a > mouseX + 3) {
        // bump up by
        board[a] += 10;
      }
      set(mouseX, board[mouseX], color((board[a]%135), 125, (board[a]%240)));
    }
  }
}

int top_offset = 10;

void display() {
  for (int a = 0; a < 640; a++) {
    for (int b = 0; b < top_offset; b++) {
      set(a, b, color((board[a]%255), 125, (board[a]%125)));
      //set(i, k, white);
    }
  }
  for (int i = 0; i < 640; i++) {
    for (int k = 0; k < board[i]; k++) {
      set(i, k + top_offset, color((board[i]%255), 125, (board[i]%125)));
      //set(i, k, white);
    }
  }
}

void setup() {
  size(640, 460);
  //size(640, 360);
  background(255);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  
  for (int i = 0; i < 640; i++) {
    board[i] = 0;
  }
}      

void draw() {
  background(0);
  shift();
  display();
  nudge();
}
