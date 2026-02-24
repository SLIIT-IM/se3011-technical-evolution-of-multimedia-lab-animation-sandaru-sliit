// ball
float x, y;
float xs = 3;    
float ys = -3;
float r = 12;

int hitCounts = 0;
int highScore = 0;

// walls
int wallCount = 7;
float[] wallX = new float[wallCount];
float[] wallY = new float[wallCount];
float wallW = 50;
float wallH = 12;

// paddle
float paddleX, paddleY;
float paddleW = 100;
float paddleH = 15;
float paddleSpeed = 15;

boolean gameStarted = false;

int lastSpeedIncreaseTime = 0;  
int speedInterval = 5000;       
float speedMultiplier = 1.1;    

void setup() {
  size(500, 500);
  resetGame();
}

void draw() {
  background(255);
  
  if(!gameStarted){
    textSize(25);
    textAlign(CENTER, CENTER);
    text("Press Enter to Strat", width/ 2, height/2);
  }
  // move paddle
  if (keyPressed) {
    if (keyCode == LEFT)  paddleX -= paddleSpeed;
    if (keyCode == RIGHT) paddleX += paddleSpeed;
  }
  paddleX = constrain(paddleX, 0, width - paddleW);

  if (gameStarted) {
    // move ball
    x += xs;
    y += ys;
  
    // speed increase
    if (millis() - lastSpeedIncreaseTime >= speedInterval) {
      xs *= speedMultiplier;
      ys *= speedMultiplier;
      lastSpeedIncreaseTime = millis();
    }
  } else {
    
    x = paddleX + paddleW/2; // move ball with paddle
    y = paddleY - r;         // ball on paddle
  }

  // bounce off side/top walls
  if (x < r || x > width - r) xs *= -1;
  if (y < r) ys *= -1;

  float wallSpeed = 20.0 / 60; 

  // draw walls
  fill(0);
  for (int i = 0; i < wallCount; i++) {
    wallX[i] += -wallSpeed;
    if (wallX[i] < -wallW) wallX[i] = width; // wrap walls
    rect(wallX[i], wallY[i], wallW, wallH);

    if (x > wallX[i] && x < wallX[i] + wallW &&
        y - r < wallY[i] + wallH && y + r > wallY[i]) {
      ys *= -1;
    }
  }

  if (x > paddleX && x < paddleX + paddleW &&
      y + r >= paddleY && y - r <= paddleY + paddleH) {
    ys *= -1;              
    y = paddleY - r;       
    if(gameStarted) hitCounts++;
  }

  
  if (y - r > height) {
    resetGame();
  }

  // draw paddle
  fill(100);
  rect(paddleX, paddleY, paddleW, paddleH);

  // draw ball
  fill(200, 50, 50);
  ellipse(x, y, r * 2, r * 2);
  drawMarks();
}

void resetGame() {
  // ball start position
  x = width / 2;
  y = height - 60;
  xs = 3;
  ys = -3;

  lastSpeedIncreaseTime = millis(); // reset timer

  // paddle start
  paddleX = width / 2 - paddleW / 2;
  paddleY = height - 30;

  // random walls
  for (int i = 0; i < wallCount; i++) {
    wallX[i] = 60 + i * 100 + random(-10, 10);
    wallY[i] = random(60, height - 120);
  }

  gameStarted = false; 
  hitCounts = 0;
}

// KEY PRESS
void keyPressed() {
  if (key == 'r' || key == 'R') {
    resetGame();      
  }

  if (keyCode == ENTER) {
    gameStarted = true;  
  }
}

void drawMarks() {
  fill(0);
  if(highScore <= hitCounts * 10) highScore = hitCounts * 10;
  textSize(13);
  textAlign(LEFT, TOP);
  text("Highest score : " + "000" + highScore, 20, 40);
  textSize(16);
  text("Score: 000" + hitCounts * 10, 20, 20);  
}
