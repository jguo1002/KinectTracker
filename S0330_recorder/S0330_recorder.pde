import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI  kinect;
boolean       autoCalib=true;


SkeletonRecorder recorder; // declare the class
boolean recording = false;
float offByDistance = 0.0;

void setup() {
  size(1028, 768, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  kinect.setMirror(true); // make mirror effect 
  
  // initialize our recorder and tell it to track left hand
  recorder = new SkeletonRecorder(kinect, SimpleOpenNI.SKEL_TORSO);
  
  // load a font 
  PFont font = createFont("Verdana", 40);
  textFont(font);
}

void draw() {
  kinect.update();
  image(kinect.depthImage(),0,0);
  background(255);
  
  //create heads-up displays
  fill(0);
  text("totalFrames: " + recorder.frames.size(), 5, 50);
  text("recording: " + recording, 5, 1000);
  text("currentFrame: " + recorder.currentFrame, 5, 150 );
  // set text color as a gradient from red to green based on distance between hands
  float c = map(offByDistance, 0, 1000, 0, 255);
  fill(c, 255-c, 0);
  text("off by:" + offByDistance, 5, 200);
  translate(width/2, height/2, 0);
  rotateX(radians(180));
  
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
  if (userList.size() > 0) {
    int userId = userList.get(0);
    println(userId);
    recorder.setUser(userId);
    println("user set!");
    
    if(kinect.isTrackingSkeleton(userId)) {
      println("isTracking");
      PVector currentPosition = new PVector();
      //save position in currentPosition
      kinect.getJointPositionSkeleton(userId, 
        SimpleOpenNI.SKEL_LEFT_HAND, currentPosition);
        ellipse(currentPosition.x, currentPosition.y, 50, 50);
//        println(currentPosition.x);
    /*
    // display sphere for current limb position
    pushMatrix();
      fill(255,0,0);
    // because we use 3D view to display sphere
    // we need to translate coordinate first
    translate(currentPosition.x, currentPosition.y, currentPosition.z);
      sphere(80);
    popMatrix();
    */
    
    // if we're recording, tell the recorder to capture frame
    if (recording) {
        recorder.recordFrame();
      }
    else {
      // if we're playing, access the recorded joint position
      PVector recordedPosition = recorder.getPosition();
      ellipse(recordedPosition.x, recordedPosition.y, 50, 50);
      
      /*
      // display recorded position
      pushMatrix();
        fill(0,255,0);
        translate(recordedPosition.x, recordedPosition.y, recordedPosition.z);
        sphere(80);
      popMatrix();
      
      // draw a line between the current position and the recorded one
      // set its color based on the distance between the two
      stroke(c, 255-c, 0);
      strokeWeight(20);
      line(currentPosition.x, currentPosition.y, currentPosition.z, 
          recordedPosition.x, recordedPosition.y, recordedPosition.z);
      */
      
      // calculate the vector between the current and recorded positions
      // with vector subtraction
      currentPosition.sub(recordedPosition);
      // store the magnitude of that vector as the off-by distance
        // for display
      offByDistance = currentPosition.mag();
      // tell the recorder to load up the next frame
      recorder.nextFrame();
    }
    } // end of if is Tracking
  }
}// end of draw

void keyPressed() {
  recording = false;
}


// ------------------------------------
// user-tracking callbacks!
void onNewUser(int userId) 
  {
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  
  if(autoCalib)
    kinect.requestCalibrationSkeleton(userId,true);
  else    
    kinect.startPoseDetection("Psi",userId);
  }

void onEndCalibration(int userId, boolean successful) {
  if (successful) { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
    recording = true;
  } 
  else { 
    println("  Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
  println("Started pose for user");
  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}


