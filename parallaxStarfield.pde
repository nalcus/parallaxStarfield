// parallaxStarfield.pde
// Copyright 2014 (c) Nicholas Alcus
// This program is provided WITHOUT WARRANTY of ANY KIND 

/* @pjs preload="title.png";  */

static final int initialStars=50;

Star stars[] = new Star[initialStars];

PImage tex = new PImage();
PImage title = new PImage();

// timing
int startTime;
int oldTime;
int newTime;
int interval;
int oldMouseX;
int oldMouseY;
float cachedDiv;

void setup () {
  
  // for desktop mode:
  size (480, 640, P3D);


  // for android mode:
  // size (displayWidth, displayHeight, P3D);
  
  noStroke();
  background (0);

  title = loadImage("title.png");

  tex = createImage(1, 1, RGB);
  tex.loadPixels();
  tex.pixels[0] = color(255, 255, 255);
  tex.updatePixels();

  oldTime=millis();
  newTime=millis();
  interval=newTime-oldTime;

  for (int i=0;i<initialStars;i++) {
    stars[i] = new Star(noise(i, 0)*width, noise(0, i)*height, 0.5, 0.1, 1+random(3));
    // iterate them so they get really spread out
    for (int j=0;j<600;j++)
      stars[i].update(10);
  }
  oldMouseX=mouseX;
  oldMouseY=mouseY;

  cachedDiv=-2.0/width;
}

void draw()
{
  background(0);
  oldTime=newTime;
  newTime=millis();
  interval=newTime-oldTime;
  for (int i=0;i<initialStars;i++) {
    stars[i].update(interval);
    stars[i].render();
  }
  if (oldMouseX!=mouseX||oldMouseY!=mouseY)
  {
    PVector newVelocity = new PVector(width*0.5, height*0.5);
    newVelocity.sub(new PVector(mouseX, mouseY));
    newVelocity.mult(cachedDiv);
    newVelocity.limit(1.0);
    for (int i=0;i<initialStars;i++)
      stars[i].setVelocity(newVelocity);
  }
  oldMouseX=mouseX;
  oldMouseY=mouseY;

  colorMode (HSB, 255);

  tint((newTime*0.125)%255, abs(((newTime*0.025)%512)-255), 255, 255);
  image (title, 10, 10);
}

