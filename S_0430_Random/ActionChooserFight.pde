class ActionChooserFight extends ActionChooser
{
  public ActionChooserFight()
  {
    firstAction = "Fight_0.txt";
    sessionName = "Fight";
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
    
    int countfight = 0;
    // if foot higher than hand
    if (vecs[11].y < vecs[16].y || vecs[14].y < vecs[15].y)
      return "Fight_flyaway.txt";
      
    // put hand back and punch
    if (
        (vecs[2].x - vecs[16].x > 100 || vecs[5].x - vecs[15].x > 100) 
        && countfight == 0
        ) 
    {
      countfight = 1;
      
    }
    if (vecs[2].x < vecs[16].x || vecs[5].x < vecs[15].x) {
      countfight = 0;
    }
    if (countfight == 1) {
      println("you fight!");
      return "Fight_angry.txt";
    }
    else 
      return null;
  }
}
