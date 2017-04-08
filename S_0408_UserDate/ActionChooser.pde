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
    
    // write history
    // up 3 times
    if (vecs[15].y < vecs[0].y && vecs[16].y < vecs[0].y && historyBool[0] == false)
    {
      historyBool[0] = true;
    }
    else if ((vecs[15].y >= vecs[0].y || vecs[16].y >= vecs[0].y) && historyBool[0] == true)
    {
      historyBool[0] = false;
      history[0]++;
    }
    
    // making decision
    if (history[0] == 3)
    {
      history[0] = 0;
      return "SavedAction_3.txt";
    }
    if (vecs[12].y < vecs[15].y)
      return "SavedAction_2.txt";
    if (vecs[9].y < vecs[16].y)
      return "SavedAction_1.txt";
    else 
      return null;
  }
}
