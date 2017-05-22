import SimpleOpenNI.*;
import java.util.Random;
SimpleOpenNI context;
boolean autoCalib = true;
Random random = new Random();

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
int sessionId = 0;
ActionChooser actionChooser = getRandomChooser();
String currentSession = actionChooser.sessionName;

int startLatency = 0;

// for background drawing
boolean needRefresh = false;
PShape s; 
ArrayList ve; 
int nve = 1; 

// max length of segments 
float slen = 5.0; 
// scale factor for the image 
float sf = 1; 
String svgFile = actionChooser.bgSvg; 

int recordIdx = 0;
int showIdx = 0;

// max length of segments 
 

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
  actionToRecord = new Action(3000);
  actionLoaded = new Action(3000);
  currentFileName = actionChooser.firstAction;
  actionLoaded.load(currentFileName);
  
  // for background drawing
  ve = new ArrayList(); 
  s = loadShape(svgFile); 
  s.scale(sf);
  exVert(s, sf);
  
  smooth();
//  size(context.depthWidth(), context.depthHeight()); 
  size(800,800);
  frameRate(30);
  background(255);
}

void draw()
{
  // update the cam
  context.update();
  context.setMirror(true);
  // draw depthImageMap
  // image(context.depthImage(),0,0, 32, 24, 50);
  //image(context.depthImage(),0,0);
  if (needRefresh) {
      background(255);
      shape(s); 
      translate(0, 150);
  }
  // record every frame, load them all in setup, use each of them to refresh

  if (needRefresh) {
    for (int i = 0; i < 5; i++){
      if(context.isTrackingSkeleton(i))
      {
        SkeletonData data = drawSkeleton(i);
        
        if (i != 1)
          continue;
          
        recordAction(actionToRecord, data);
        

        showLoadedAction(actionLoaded);
        
        startLatency++;
        if (startLatency < 1 * 30)
          continue;
        
        String filename = actionChooser.choose(data, actionLoaded);
        if (filename != null)
        {
          actionLoaded = new Action();
          currentFileName = filename;
          actionLoaded.load(currentFileName);
        }
        
        else if (actionLoaded.currentIdx == 0)
        {
          actionLoaded = new Action(3000);
          actionChooser = getRandomChooser();
          currentFileName = actionChooser.firstAction;
          currentSession = actionChooser.sessionName;
          startLatency = 0;
          actionLoaded.load(currentFileName);
          // for background drawing
          ve = new ArrayList(); 
          nve = 0;
          s = loadShape(actionChooser.bgSvg); 
          s.scale(sf);
          exVert(s, sf);
          needRefresh = false;
          background(255);
        }     
      
      }
    }
  }
  else {
    if(nve < ve.size() && ((Point) ve.get(nve)).z != -10.0) // a way to separate distinct paths 
    {
    stroke(186,147,216);
    strokeWeight(4);
    line(((Point) ve.get(nve-1)).x, ((Point) ve.get(nve-1)).y, 
        ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y); 
  //  ellipse( ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y, 2, 2 ); 
    }
    nve++;
    if(nve < ve.size() && ((Point) ve.get(nve)).z != -10.0) // a way to separate distinct paths 
    {
    stroke(186,147,216);
    strokeWeight(4);
    line(((Point) ve.get(nve-1)).x, ((Point) ve.get(nve-1)).y, 
        ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y); 
  //  ellipse( ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y, 2, 2 ); 
    }
    nve++;
    if(nve < ve.size() && ((Point) ve.get(nve)).z != -10.0) // a way to separate distinct paths 
    {
    stroke(186,147,216);
    strokeWeight(4);
    line(((Point) ve.get(nve-1)).x, ((Point) ve.get(nve-1)).y, 
        ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y); 
  //  ellipse( ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y, 2, 2 ); 
    }
    nve++;
    if(nve < ve.size() && ((Point) ve.get(nve)).z != -10.0) // a way to separate distinct paths 
    {
    stroke(186,147,216);
    strokeWeight(4);
    line(((Point) ve.get(nve-1)).x, ((Point) ve.get(nve-1)).y, 
        ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y); 
  //  ellipse( ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y, 2, 2 ); 
    }
    nve++;
    if(nve < ve.size() && ((Point) ve.get(nve)).z != -10.0) // a way to separate distinct paths 
    {
    stroke(186,147,216);
    strokeWeight(4);
    line(((Point) ve.get(nve-1)).x, ((Point) ve.get(nve-1)).y, 
        ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y); 
  //  ellipse( ((Point) ve.get(nve)).x, ((Point) ve.get(nve)).y, 2, 2 ); 
    }
    nve++;
    if (nve >= ve.size()) {
      needRefresh = true;
      s = loadShape(actionChooser.bgOutline);
    }
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

ActionChooser getRandomChooser(){
  sessionId = (sessionId + 1) % 4;
  if (sessionId == 0)
    return new ActionChooserDance();
  if (sessionId == 1)
    return new ActionChooserFight();
  if (sessionId == 2)
    return new ActionChooserHappy();
  if (sessionId == 3)
    return new ActionChooserSad();
  return new ActionChooserDance();
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
  if (userId == 1)
    stroke(255, 0, 0, 63);
  else
    stroke(123, 63);
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

// for background drawing
void exVert(PShape s, float sf) { 
  PShape[] ch; // children 
  int n, i; 
  
  n = s.getChildCount(); 
  if (n > 0) {
    for (i = 0; i < n; i++) { 
      ch = s.getChildren(); 
      exVert(ch[i], sf); 
      }
  }
  else { // no children -> work on vertex 
    n = s.getVertexCount(); 
    //println("vertex count: " + n + " getFamily():" + s.getFamily()+ " isVisible():" + s.isVisible()); 
    for (i = 0; i < n; i++) {
    float x = s.getVertexX(i)*sf; 
    float y = s.getVertexY(i)*sf; 
    // println(i + ") getVertexCode:"+s.getVertexCode(i)); 
      if (i>0) {
        float ox = s.getVertexX(i-1)*sf; 
        float oy = s.getVertexY(i-1)*sf; 
        stepToVert(ox, oy, x, y, slen); 
      }
      else {
      ve.add(new Point(x, y, -10.0)); 
      }
    } //  end of for
  } // end of else
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// fill in with points, if needed, from (ox, oy) to (x, y) 
// 
void stepToVert(float ox, float oy, float x, float y, float slen) { 

  int i; 
  float n; 
  float dt = dist(ox, oy, x, y); 
  if ( dt > slen) {
    n = floor(dt/slen); 
    // println("Adding "+n+" points..."); 
    for (i = 0; i < n; i++) {
      float nx = lerp(ox, x, (i+1)/(n+1)); 
      float ny = lerp(oy, y, (i+1)/(n+1)); 
      ve.add(new Point(nx, ny, 0)); 
    } 
  }
  ve.add(new Point(x, y, 0)); 
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// myClass for a 3D point 
// 
class Point {
  float x, y, z; 
  Point(float x, float y, float z) {
    this.x = x; 
    this.y = y; 
    this.z = z; 
  } 
  
  void set(float x, float y, float z) {
    this.x = x; 
    this.y = y; 
    this.z = z; 
  } 
} 
