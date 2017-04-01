class SkeletonRecorder {
  SimpleOpenNI context;
  int jointID;
  int userID;
  ArrayList<PVector> frames; // save position of joints
  int currentFrame = 0;
  
  // constructor
  SkeletonRecorder(SimpleOpenNI tempcontext, int tempjointID) {
    context = tempcontext;
    jointID = tempjointID;
    frames = new ArrayList();
  } // end of SkeletonRecorder
  
  void setUser(int tempUserID) {
    userID = tempUserID;
  }
  
  void recordFrame() {
    PVector position = new PVector();
    context.getJointPositionSkeleton(userID, jointID, position);
    frames.add(position); // add to the end of ArrayList
  }
  
  PVector getPosition() {
    return frames.get(currentFrame);
  }
  
  void nextFrame() {
    currentFrame++;
    if(currentFrame == frames.size()) {
      currentFrame = 0; // start from beginning when at the end
    }
  }
}
  
  
  
