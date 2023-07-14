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
    //println(height);
  }
}

void display() {
  for (int i = 0; i < 640; i++) {
    for (int k = 0; k < board[i]; k++) {
      set(i, k, color((board[i]%255), 0, (board[i]%255)));
      //set(i, k, white);
    }
  }
}

void setup() {
  size(640, 360);
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
  //println(amp.analyze());
  /*
  int height = (int) (amp.analyze() * 360);
  for (int i = 0; i < height; i++) {
    delay(1000);
    set(25, i, white);
  }
  */
  shift();
  display();
  delay(100);
}
