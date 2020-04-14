import processing.serial.*;
Serial myPort;  // Create object from Serial class

import controlP5.*;

ControlP5 cp5;

float step = height/1.3;
int margin = int(step-30);
color globalColor = #FF0000;

int LedAblink = 0;
int LedBblink = 0;
int LedCblink = 0;
int LedDblink = 0;
int LedEblink = 0;
int picoBuckA = 0;
int picoBuckB = 0;
int picoBuckC = 0;

boolean toggleValueA = false;
boolean toggleValueB = false;
boolean toggleValueC = false;
boolean toggleValueD = false;
boolean toggleValueE = false;

int LedAtoggle = 0;
int LedBtoggle = 0;
int LedCtoggle = 0;
int LedDtoggle = 0;
int LedEtoggle = 0;

byte out[] = new byte[14];
byte prevOut[] = new byte[14];



final int MAX_PARTICLES = 800; 
ArrayList<Particle_c> particles;




void setup() {
  //size(700, 400);
  noStroke();
   fullScreen();
   background(0);


  // Particles setup
  int i;
  particles = new ArrayList<Particle_c>();
  // Create n number of particles, pass unique id. 
  for ( i = 0; i < MAX_PARTICLES; i++ ) particles.add( new Particle_c( i ) );


  //String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  //myPort = new Serial(this, "/dev/cu.usbmodem1421", 9600);  

  cp5 = new ControlP5(this);


  cp5.addSlider("LedAblink").setPosition(width/3, step).setSize(300, margin).setRange(0, 254);
  cp5.addSlider("LedBblink").setPosition(width/3, step*2).setSize(300, margin).setRange(0, 254);
  cp5.addSlider("LedCblink").setPosition(width/3, step*3).setSize(300, margin).setRange(0, 254);
  cp5.addSlider("LedDblink").setPosition(width/3, step*4).setSize(300, margin).setRange(0, 254);
  cp5.addSlider("LedEblink").setPosition(width/3, step*5).setSize(300, margin).setRange(0, 254);

  cp5.addSlider("picoBuckA").setPosition(width/3, step*6).setSize(300, margin).setRange(0, 254);
  cp5.addSlider("picoBuckB").setPosition(width/3, step*7).setSize(300, margin).setRange(0, 254);
  cp5.addSlider("picoBuckC").setPosition(width/3, step*8).setSize(300, margin).setRange(0, 254);

   cp5.setColorForeground(globalColor);
   cp5.setColorBackground(#FFFFFF);
   cp5.setColorActive(globalColor);
   cp5.setColorValueLabel(#000000);

  cp5.addToggle("toggleValueA")
    .setPosition(width/5, step)
    .setSize(margin*2, margin)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("toggleValueB")
    .setPosition(width/5, step*2)
    .setSize(margin*2, margin)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("toggleValueC")
    .setPosition(width/5, step*3)
    .setSize(margin*2, margin)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("toggleValueD")
    .setPosition(width/5, step*4)
    .setSize(margin*2, margin)
    .setMode(ControlP5.SWITCH)
    ;

  cp5.addToggle("toggleValueE")
    .setPosition(width/5, step*5)
    .setSize(margin*2, margin)
    .setMode(ControlP5.SWITCH)
    ;
}

void draw() {




  background(0);
  
  // Each particle updates.
  for ( Particle_c p : particles ) p.update();
  
  
  
  
  
  if (toggleValueA ==true) {
    LedAtoggle=1;
  } else {
    LedAtoggle=0;
  }
  if (toggleValueB ==true) {
    LedBtoggle=1;
  } else {
    LedBtoggle=0;
  }
  if (toggleValueC ==true) {
    LedCtoggle=1;
  } else {
    LedCtoggle=0;
  }
  if (toggleValueD ==true) {
    LedDtoggle=1;
  } else {
    LedDtoggle=0;
  }
  if (toggleValueE ==true) {
    LedEtoggle=1;
  } else {
    LedEtoggle=0;
  }  

  out[0] = byte(LedAblink);
  out[1] = byte(LedBblink);
  out[2] = byte(LedCblink);
  out[3] = byte(LedDblink);
  out[4] = byte(LedEblink);
  out[5] = byte(LedAtoggle);
  out[6] = byte(LedBtoggle);
  out[7] = byte(LedCtoggle);
  out[8] = byte(LedDtoggle);
  out[9] = byte(LedEtoggle);
  out[10] = byte(picoBuckA);
  out[11] = byte(picoBuckB);
  out[12] = byte(picoBuckC);
  out[13] = byte(255);

  for (int i = 0; i < 13; i++)
  {
    if (out[i] != prevOut[i])
    {
      myPort.write(out);
      prevOut[i] = out[i];
      println(out[2]);
      delay(100);
    }
  }
}










// A class which represents a particle in 2D space and takes care of
// all it's own colisions and dynamics.  
class Particle_c {
  PVector position;
  PVector velocity;
  int id;
  float r, m;

  
  // Constructor, id required to check against self-collision later.
  Particle_c( int _id ) {
     position = new PVector( random(0,width), random(0,height) );
     velocity = new PVector();
     //velocity = PVector.random2D();
     //velocity.mult(3);
     
     r = random(0.5,5);
     m = r *  0.1;
     id = _id;
  }


  // This one function follows an update procedure and completes
  // all steps to draw to the screen.
  void update() {
    
    // Defines a new velocity if collision occurs.
    checkCollisionWithOthers();
    
    // Modifies velocity against window border
    checkBoundaryCollision();
    
    // Modifies velocity with respect to mouse click.
    checkAgainstMouse();
    
    // Slowly reduces any velocity to zero.
    applyFriction();
    
    // Apply velocity for this update cycle.
    position.add(velocity);
    
    // Draw to screen.
    display();
  }
  
  // When the mouse is clicked, this object will check if it is
  // a radius of influence (50) and if so, moves away by adding
  // a distance proportional velocity.  
  void checkAgainstMouse() {
    
    if( mousePressed == true ) {
      
       // Mouse vector.
       PVector mVect = new PVector( mouseX, mouseY );
       
       // Distance between object and mouse.
       float d = PVector.dist( position, mVect );
       
       // CHeck if in radius.
       if( d < 30 ) { 
         
         // Subtract vectors to get a vector from origin (0,0)
         PVector bVect = PVector.sub( mVect, position );
         
         float theta;
         theta = atan2( mVect.y - position.y, mVect.x - position.x );
         
         // Inverse d, so that the further from the mouse,
         // the slower the additional velocity away. 
         d = 130 - d;
         velocity.x -= ( d * cos( theta) ) * 0.02;
         velocity.y -= ( d * sin( theta) ) * 0.02;
       }
          
    } 
  }
  
  // Simply multiply by a small number.
  void applyFriction() {
     velocity.mult(0.995);
  }
  
  // Use this objects ID number to check against all
  // other objects in the global array list.
  void checkCollisionWithOthers() {
     int i;
     for( i = 0; i < particles.size(); i++ ) {
        if( i != id ) {
           // If not self, grab instance of particle
           // and run through collision routine.
           Particle_c p = particles.get(i);
           checkCollision( p );
        }
     } 
  }
  

  // Alternative collision with screen, wrap around edges
  // instead.
  void wrapBoundaryCollision() {
     if( position.x > width ) position.x -= width;
     if( position.x < 0 ) position.x += width;
     if( position.y < 0 ) position.y += height;
     if( position.y > height ) position.y -= height; 
  }

  // Inverse the velocity depending on the screen
  // edge collision.
  void checkBoundaryCollision() {
    if (position.x > width-r) {
      position.x = width-r;
      velocity.x *= -1;
    } 
    else if (position.x < r) {
      position.x = r;
      velocity.x *= -1;
    } 
    else if (position.y > height-r) {
      position.y = height-r;
      velocity.y *= -1;
    } 
    else if (position.y < r) {
      position.y = r;
      velocity.y *= -1;
    }
  }

  void checkCollision(Particle_c other) {

    // get distances between the balls components
    PVector bVect = PVector.sub(other.position, position);

    // calculate magnitude of the vector separating the balls
    float bVectMag = bVect.mag();

    // If there is contact
    if (bVectMag < r + other.r) {
      
      // heading() is not working on openprocessing.org
      // get angle of bVect
      //float theta  = bVect.heading();
      float theta;
      theta = atan2( other.position.y - position.y, other.position.x - position.x );
      
      
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
        };

        /* this ball's position is relative to the other
         so you can use the vector between them (bVect) as the 
         reference point in the rotation expressions.
         bTemp[0].position.x and bTemp[0].position.y will initialize
         automatically to 0.0, which is what you want
         since b[1] will rotate around b[0] */
        bTemp[1].x  = cosine * bVect.x + sine * bVect.y;
      bTemp[1].y  = cosine * bVect.y - sine * bVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
        };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
        };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
        };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);
      
      // add the overlap distance to stop clumping.
      float overlap = (r + other.r) - bVectMag;
      position.x -= cos( theta ) * overlap;
      position.x -= sin( theta ) * overlap;  

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
    }
  }


  void display() {
    noStroke();
    fill(204);
    ellipse(position.x, position.y, r*2, r*2);
  }
}