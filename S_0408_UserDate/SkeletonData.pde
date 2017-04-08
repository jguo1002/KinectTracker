class SkeletonData
{
  public PVector[] vectors;
  
  public SkeletonData()
  {
    vectors = new PVector[17]; 
  }
  
  public SkeletonData(String line)
  {
    vectors = new PVector[17];
    String[] vecStrs = line.trim().split("\t");
    if (vecStrs.length != 17)
    {
      println("Invalid line!");
      return;
    }
    for (int i = 0; i < 17; i++)
    {
      String[] numStrs = vecStrs[i].split(",");
      float x = Float.parseFloat(numStrs[0]);
      float y = Float.parseFloat(numStrs[1]);
      float z = Float.parseFloat(numStrs[2]);
      vectors[i] = new PVector(x, y, z);
    }
  }
  
  public String toString()
  {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < 17; i++)
    {
      if (vectors[i] == null)
      {
        //println("Wrong in " + i + " !!!");
        vectors[i] = new PVector(0, 0, 0);
      }
      sb.append(vectors[i].x + "," + vectors[i].y + "," + vectors[i].z + "\t");
    }
    return sb.toString(); 
  }
}

