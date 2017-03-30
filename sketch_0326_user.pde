import SimpleOpenNI.*;
SimpleOpenNI  context;
boolean       autoCalib=true;

void setup()
{
  context = new SimpleOpenNI(this);
   
  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  context.enableScene();
  
  
  smooth();
//  size(context.depthWidth(), context.depthHeight()); 
  size(1024,480);
}

void draw()
{
  // update the cam
  context.update();
  
  // draw depthImageMap
  //  image(context.depthImage(),0,0, 32, 24, 50);
  image(context.depthImage(),0,0);
  background(255);  
  
  // draw the skeleton if it's available
  if(context.isTrackingSkeleton(1))
    drawSkeleton(1);
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,jointPos);
  println("jointPos + : " + jointPos);
  
  stroke(255, 0, 0, 63);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  strokeWeight(12);
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  
  drawJoint1(userId, SimpleOpenNI.SKEL_HEAD);
  drawJoint2(userId, SimpleOpenNI.SKEL_HEAD);
  drawJoint2(userId, SimpleOpenNI.SKEL_NECK);
  drawJoint2(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  drawJoint2(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
  drawJoint2(userId, SimpleOpenNI.SKEL_NECK);
  drawJoint2(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  drawJoint2(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  drawJoint2(userId, SimpleOpenNI.SKEL_TORSO);
  drawJoint2(userId, SimpleOpenNI.SKEL_LEFT_HIP);  
  drawJoint2(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
  drawJoint2(userId, SimpleOpenNI.SKEL_RIGHT_HIP);  
  drawJoint2(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
  drawJoint2(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
  drawJoint2(userId, SimpleOpenNI.SKEL_LEFT_HIP);  
  drawJoint2(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
  drawJoint2(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
  drawJoint2(userId, SimpleOpenNI.SKEL_LEFT_HAND);
}

void drawJoint1(int userId, int jointID) {
  PVector joint = new PVector();
  float confidence = context.getJointPositionSkeleton(userId, jointID, joint);
  if(confidence < 0.5){
    return;
  }
  PVector convertedJoint = new PVector();
  context.convertRealWorldToProjective(joint, convertedJoint);
  fill(255, 0, 0, 63);
  noStroke();
  ellipse(convertedJoint.x, convertedJoint.y, 50, 50);
}

void drawJoint2(int userId, int jointID) {
  PVector joint = new PVector();
  float confidence = context.getJointPositionSkeleton(userId, jointID, joint);
  if(confidence < 0.5){
    return;
  }
  PVector convertedJoint = new PVector();
  context.convertRealWorldToProjective(joint, convertedJoint);
  fill(255, 127);
  noStroke();
  ellipse(convertedJoint.x, convertedJoint.y, 12, 12);
}


// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  
  if(autoCalib)
    context.requestCalibrationSkeleton(userId,true);
  else    
    context.startPoseDetection("Psi",userId);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  
  if (successfull) 
  { 
    println("  User calibrated !!!");
    context.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    context.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose,int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");
  
  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
 
}

void onEndPose(String pose,int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}

