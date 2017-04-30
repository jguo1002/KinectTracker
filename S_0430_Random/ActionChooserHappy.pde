class ActionChooserHappy extends ActionChooser
{
  public ActionChooserHappy()
  {
    firstAction = "happy_0.txt";
    sessionName = "Happy";
  }
  
  public String choose(SkeletonData data, Action currentAction)
  {
    if (data == null)
      return null;
      
    PVector[] vecs = data.vectors;
    for (int i = 0; i < 17; i++)
    {
      if (vecs[i] == null)
        return null;
    }
    /*
    // making decision
    if (vecs[2].x - vecs[16].x > 100)
    {
//      return "Fight_1.txt";
      return "happy_3.txt";
    }
    else 
      return null;
    */
    
    // wave hand for 3 times
    int countfight = 0;
  if(vecs[0].y - vecs[15].y > 50 || vecs[0].y - vecs[16].y > 50) {
    println("raise your hand!");
    if ((vecs[15].x < vecs[5].x || vecs[16].x < vecs[2].x) && historyBool[0] == false)
    {
      historyBool[0] = true;
    }
    else if ((vecs[15].x - vecs[5].x > 50 || vecs[16].x - vecs[2].x > 50) && historyBool[0] == true)
    {
      historyBool[0] = false;
      history[0]++;
    }
  }//end of if vecs[15]
  
    // making decision
    if (history[0] == 2)
    {
      history[0] = 0;
      return "happy_2.txt";
    }
    // if foot higher than hand
    if (vecs[11].y < vecs[16].y || vecs[14].y < vecs[15].y)
      return "Fight_flyaway.txt";
    
    /**
    // put hand back and punch
    if ((vecs[2].x - vecs[16].x > 100 || vecs[5].x - vecs[15].x > 100) && countfight == 0) {
      countfight = 1;
      println("you fight!");
    }
    if (vecs[2].x < vecs[16].x || vecs[5].x < vecs[15].x) {
      countfight = 0;
    }
    if (countfight == 1) {
      return "Fight_punch.txt";
    }
    */
    else
      return null;
  
  } // end of String chooose
}
