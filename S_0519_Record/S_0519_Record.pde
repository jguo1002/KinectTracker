import SimpleOpenNI.*;
SimpleOpenNI context;
boolean autoCalib = true;

// for recording
boolean isRecording = false;
int actionId = 0;
Action actionToRecord;
// for loading
Action actionLoaded;
String currentFileName;
int showId = 0;

// for showing
boolean isEcho = true;
ActionChooser actionChooser = new ActionChooser();

final static int RECORD_FRAME_NUM = 300;
int RecordCount = 0;
PShape bg; 

void setup()
{
  bg = loadShape("boxing-outline.svg");
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
  
  // initialize data record
  actionToRecord = new Action(3000);
  actionLoaded = new Action(3000);
//  currentFileName = "dance_g_int_bow_me_a0_invite.txt";
  currentFileName = "fight_b_guard_sway.txt"; // for test 
  actionLoaded.load(currentFileName);
  
  // load an action
  // loadList = loadAction("SavedAction_3.txt");
  
  smooth();
//  size(context.depthWidth(), context.depthHeight()); 
  size(800,800);
  frameRate(30);
}

void draw()
{
  // update the cam
  context.update();
  context.setMirror(true);
  // draw depthImageMap
  // image(context.depthImage(),0,0, 32, 24, 50);
  
  image(context.depthImage(),0,0);
  background(255);
  shape(bg); 
  
//  rect(310, 110, 40, 100); // for sad_hug area
//  rect(427, 128, 20, 20); // for sad_hug head position
//  fill(255, 0, 0, 63);
  translate(0, 150);
  if(context.isTrackingSkeleton(1))
  {
    SkeletonData data = drawSkeleton(1);
    recordAction(actionToRecord, data);
    
    String filename = actionChooser.choose(data);
    if (filename != null)
    {
      actionLoaded = new Action();
      currentFileName = filename;
      actionLoaded.load(currentFileName);
      
    }
    
    else if (actionLoaded.currentIdx == 0)
    {
      actionLoaded = new Action();
//      getFileNameTemp(RecordCount); // getFileName
//      RecordCount++;
//      if (RecordCount == 3) {
//        RecordCount = 0;
//      }
      actionLoaded.load(currentFileName);
      println(currentFileName);
//      println(RecordCount);
    }
//    println(currentFileName);
    showLoadedAction(actionLoaded);
  }
}

void keyPressed()
{
  if (key == 'b')
  {
    isRecording = true;
    println("Begin recording");
  }
  else if (key == 'e')
  {
    isRecording= false;
    actionToRecord.finishAndRecord("SavedAction_" + actionId + ".txt");
    actionId++;
    actionToRecord = new Action();
    println("End recording");
  }
  else if (key == 'c')
  {
    actionLoaded = new Action();
    String filename = dataPath("SavedAction_" + showId + ".txt");
    showId++;
    actionLoaded.load(filename);
  }
}

void recordAction(Action action, SkeletonData data)
{
  if (!isRecording)
    return;
    
  int result = action.addFrame(data);
  // finish recording because don't have place for more frames
  if (result == -1)
  {
    isRecording = false;
    action.finishAndRecord("SavedAction_" + actionId + ".txt");
    actionId++;
    actionToRecord = new Action();
    println("End recording");
  }
}

void showLoadedAction(Action action)
{
  // show loaded action
  SkeletonData data = action.frames[action.currentIdx];
  drawSkeletonData(data);
  action.currentIdx = (action.currentIdx + 1) % action.frameNum;
}

void drawSkeletonData(SkeletonData data)
{
  PVector[] vecs = data.vectors;
  fill(156,117,255,164);
  noStroke();
  if (vecs[0].x != 0 && vecs[0].y != 0)
  {
    ellipse(vecs[0].x, vecs[0].y, 50, 50);
  }
  
  stroke(156,117,255,164);
  
  /*
  // puppet
  strokeWeight(2);
  myLine(vecs[15].x, vecs[15].y, vecs[15].x + 5, 0);
  myLine(vecs[16].x, vecs[16].y, vecs[16].x - 5, 0);
  myLine(vecs[9].x, vecs[9].y, vecs[9].x - 5, 0);
  myLine(vecs[12].x, vecs[12].y, vecs[12].x + 5, 0);
  */
  
  strokeWeight(12);
  myLine(vecs[0].x, vecs[0].y, vecs[1].x, vecs[1].y);
  myLine(vecs[1].x, vecs[1].y, vecs[2].x, vecs[2].y);
  myLine(vecs[2].x, vecs[2].y, vecs[3].x, vecs[3].y);
  myLine(vecs[3].x, vecs[3].y, vecs[16].x, vecs[16].y);
  
  myLine(vecs[1].x, vecs[1].y, vecs[5].x, vecs[5].y);
  myLine(vecs[5].x, vecs[5].y, vecs[6].x, vecs[6].y);
  myLine(vecs[6].x, vecs[6].y, vecs[15].x, vecs[15].y);
  
  myLine(vecs[2].x, vecs[2].y, vecs[7].x, vecs[7].y);
  myLine(vecs[5].x, vecs[5].y, vecs[7].x, vecs[7].y);
  
  myLine(vecs[7].x, vecs[7].y, vecs[8].x, vecs[8].y);
  myLine(vecs[8].x, vecs[8].y, vecs[9].x, vecs[9].y);
  myLine(vecs[9].x, vecs[9].y, vecs[11].x, vecs[11].y);
  
  myLine(vecs[7].x, vecs[7].y, vecs[10].x, vecs[10].y);
  myLine(vecs[10].x, vecs[10].y, vecs[12].x, vecs[12].y);
  myLine(vecs[12].x, vecs[12].y, vecs[14].x, vecs[14].y);
}

void myLine(float x1, float y1, float x2, float y2)
{
  if (x1 == 0 && y1 == 0 || x2 == 0 && y2 == 0)
    return;
  
  line(x1, y1, x2, y2);
}

// draw the skeleton with the selected joints
SkeletonData drawSkeleton(int userId)
{
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
  
  SkeletonData data = new SkeletonData();
  drawJoint1(userId, SimpleOpenNI.SKEL_HEAD);
  data.vectors[0] = drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
  data.vectors[1] = drawJoint(userId, SimpleOpenNI.SKEL_NECK);
  data.vectors[2] = drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  data.vectors[3] = drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
  data.vectors[4] = drawJoint(userId, SimpleOpenNI.SKEL_NECK);
  data.vectors[5] = drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  data.vectors[6] = drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  data.vectors[7] = drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
  data.vectors[8] = drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);  
  data.vectors[9] = drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
  data.vectors[10] = drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);  
  data.vectors[11] = drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
  data.vectors[12] = drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
  data.vectors[13] = drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);  
  data.vectors[14] = drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
  data.vectors[15] = drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
  data.vectors[16] = drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
  return data;
} // end of SkeletonData drawSkeleton

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
//  date(userId, convertedJoint.x, convertedJoint.y);
}
  
PVector drawJoint(int userId, int jointID) {
  PVector joint = new PVector();
  float confidence = context.getJointPositionSkeleton(userId, jointID, joint);
  if(confidence < 0.5){
    return null;
  }
  PVector convertedJoint = new PVector();
  context.convertRealWorldToProjective(joint, convertedJoint);
  fill(255, 127);
  noStroke();  
  ellipse(convertedJoint.x, convertedJoint.y, 12, 12);
  return convertedJoint;
}
// ---------------------

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

