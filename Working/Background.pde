class Background {
  public int maxIdx = 0;
  public int currentIdx = 0;
  public PImage data[];
  
  public Background(String session) {
    currentIdx = 0;
    String prefix = "";
    if (session.equals("Fight")) {
      maxIdx = 142;
      prefix = "boxing";
    }
    else if (session.equals("Dance")) {
      maxIdx = 140;
      prefix = "dance";
    }
    else if (session.equals("Happy")) {
      maxIdx = 134; 
      prefix = "happy";
    }
    else if (session.equals("Sad")) {
      maxIdx = 140;
      prefix = "sad";
    }
      
    data = new PImage[maxIdx + 1];
    for (int i = 0; i < maxIdx + 1; i++) {
      String filepath = dataPath(prefix + "_" + i + ".jpg");
      data[i] = loadImage(filepath);
    }
  }
  
  PImage getNextFrame() {
    if (currentIdx == maxIdx)
      return data[currentIdx];
    return data[currentIdx++];
  }
}
