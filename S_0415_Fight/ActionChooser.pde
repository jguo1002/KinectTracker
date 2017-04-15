class ActionChooser
{
  public ActionChooser()
  {
    history = new int[10];
    historyBool = new boolean[10];
    for (int i = 0; i < 10; i++)
    {
      history[i] = 0;
      historyBool[i] = false;
    }
  }
  
  public int[] history;
  public boolean[] historyBool;
  
  public String choose(SkeletonData data)
  {
    if (data == null)
      return null;
      
    PVector[] vecs = data.vectors;
    for (int i = 0; i < 17; i++)
    {
      if (vecs[i] == null)
        return null;
    }
    
    // making decision
    if (vecs[2].x - vecs[16].x > 150)
    {
      
      return "Fight_1.txt";
    }
    else 
      return null;
  }
}
