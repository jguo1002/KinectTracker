import SimpleOpenNI.*;
SimpleOpenNI context;
boolean autoCalib = true;

// for recording
boolean isRecording = false;
int recordingCnt = 0;
int actionId = 0;
ArrayList<SkeletonData> recordList;
int cnt = 0;

// for loading
ArrayList<SkeletonData> loadList;
int currentFrameIdx = 0;

// for showing
boolean isEcho = true;
ActionChooser actionChooser = new ActionChooser();

final static int RECORD_FRAME_NUM = 300;

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
  
  // initialize data record
  recordList = new ArrayList<SkeletonData>();
  
  // load an action
  // loadList = loadAction("SavedAction_3.txt");
  
  smooth();
//  size(context.depthWidth(), context.depthHeight()); 
  size(1024,480);
  frameRate(30);
}

void draw()
{
  // update the cam
  context.update();
  
  // draw depthImageMap
  // image(context.depthImage(),0,0, 32, 24, 50);
  image(context.depthImage(),0,0);
  background(255);  
  
  // recordAction();
  // showLoadedAction();
  
  if(context.isTrackingSkeleton(1) && isEcho)
  {
    SkeletonData data = drawSkeleton(1);
    String filename = actionChooser.choose(data);
    if (filename != null)
    {
      loadList = loadAction(filename);
      isEcho = false;
    }
  }
  else if (!isEcho)
  {
    showLoadedAction();
  }
    
}

void keyPressed()
{
  isRecording = true;
}

ArrayList<SkeletonData> loadAction(String filename)
{
  ArrayList<SkeletonData> ret = new ArrayList<SkeletonData>();
  String filepath = dataPath(filename);
  String[] lines = loadStrings(filepath);
  for (String line : lines)
  {
    ret.add(new SkeletonData(line));
  }
  currentFrameIdx = 0;
  return ret;
}

void recordAction()
{
  // draw the skeleton if it's available
  if(context.isTrackingSkeleton(1))
  {
    SkeletonData data = drawSkeleton(1);
    if (isRecording && cnt < RECORD_FRAME_NUM)
    {
      if (cnt == 0)
        println("Begin Recording!!!");
      cnt++;
      recordList.add(data);
    }
    if (isRecording && cnt == RECORD_FRAME_NUM)
    {
      println("End Recording!!!");
      isRecording = false;
      cnt = 0;
      actionId++;
      String[] skeletonTexts = new String[RECORD_FRAME_NUM];
      for (int i = 0; i < RECORD_FRAME_NUM; i++)
      {
        skeletonTexts[i] = recordList.get(i).toString();
      }
      String filepath = dataPath("SavedAction_" + actionId + ".txt");
      saveStrings(filepath, skeletonTexts);
      recordList = new ArrayList<SkeletonData>();
    }
  }   
}

void showLoadedAction()
{
  // show loaded action
  SkeletonData data = loadList.get(currentFrameIdx);
  drawSkeletonData(data);
  if (currentFrameIdx < RECORD_FRAME_NUM - 1)
  {
    currentFrameIdx++;
  }
  else 
  {
    currentFrameIdx = 0;
    isEcho = true;
  }
}

void drawSkeletonData(SkeletonData data)
{
  PVector[] vecs = data.vectors;
  fill(255, 0, 0, 63);
  noStroke();
  if (vecs[0].x != 0 && vecs[0].y != 0)
  {
    ellipse(vecs[0].x, vecs[0].y, 50, 50);
  }
  
  stroke(123);
  
  strokeWeight(2);
  myLine(vecs[15].x, vecs[15].y, vecs[15].x + 5, 0);
  myLine(vecs[16].x, vecs[16].y, vecs[16].x - 5, 0);
  myLine(vecs[9].x, vecs[9].y, vecs[9].x - 5, 0);
  myLine(vecs[12].x, vecs[12].y, vecs[12].x + 5, 0);
  
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
  /*
  // to get the 3d joint data
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,jointPos);
  println("jointPos + : " + jointPos);
  */
  
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

