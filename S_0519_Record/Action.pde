class Action
{
  public SkeletonData frames[];
  public int frameNum;
  public int currentIdx;
  private int maxFrameNum;
  
  public Action()
  {
    frameNum = 0;
    currentIdx = 0;
    maxFrameNum = 3000;
    frames = new SkeletonData[maxFrameNum];
  }
  
  public Action(int maxFrameNum)
  {
    frameNum = 0;
    currentIdx = 0;
    this.maxFrameNum = maxFrameNum;
    frames = new SkeletonData[this.maxFrameNum];
  }
  
  int addFrame(SkeletonData data)
  {
    if (currentIdx >= maxFrameNum)
    {
      println("Too much frames!!!");
      return -1;
    }
    frames[currentIdx] = data;
    currentIdx++;
    return 0;
  }
  
  void finishAndRecord(String filename)
  {
    frameNum = currentIdx;
    String[] skeletonTexts = new String[frameNum];
    for (int i = 0; i < frameNum; i++)
    {
      skeletonTexts[i] = frames[i].toString();
    }
    String filepath = dataPath(filename);
    saveStrings(filepath, skeletonTexts);
  }
  
  void load(String filename)
  {
    String filepath = dataPath(filename);
    String[] lines = loadStrings(filepath);
    for (String line : lines)
    {
      addFrame(new SkeletonData(line));
    }
    frameNum = currentIdx;
    currentIdx = 0;
  }
}
