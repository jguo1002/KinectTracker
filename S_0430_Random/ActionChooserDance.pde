class ActionChooserDance extends ActionChooser
{
  public ActionChooserDance()
  {
    firstAction = "dance_int.txt";
    sessionName = "Dance";
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
    // feet meet 
//    history[2]=dance
    // left hand or right hand in an area
    float feetdistance = abs(vecs[11].x - vecs[14].x);
    println("feetdistance: " + feetdistance);
    if (feetdistance < 20){
      historyBool[2] = true;
      println(historyBool[2]);
    }
    if (feetdistance > 100 && historyBool[2] == true){
      history[2] ++;
      println(history[2]);
      historyBool[2] = false;
    }

    // making decision
    if (history[2] == 4){
      history[2] = 0;
      return "dance_clap.txt";
    }
    else
      return null;
  
  } // end of String chooose
}
