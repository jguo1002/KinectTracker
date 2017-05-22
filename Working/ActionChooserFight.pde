class ActionChooserFight extends ActionChooser
{
  public int[] fightNUM;
  public boolean[] fightBool;
  public int maxTired = 90;
  public int tired = 0;
  public int hitNum = 0;
  public int getHitNum = 0;
  public int hitId = 0;
  
  public ActionChooserFight()
  {
    firstAction = "Fight_0.txt";
    sessionName = "Fight";
    bgSvg = "boxing-800.svg";
    bgOutline = "boxing-outline.svg";
    fightNUM = new int[10];
    fightBool = new boolean[10];
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
    
    if (currentAction.currentIdx == 0 && (tired > 270 || hitNum > 10))
      return null;
    
    if (currentAction.actionName.equals("fight_b_guard_sway.txt")) {
      tired++;
      if (tired > maxTired) {
        if (400 < vecs[11].x && vecs[14].x < 600) {
          hitNum++;
          tired = 0;
          hitId = (hitId + 1)% 4;
          if (hitId == 0)
            return "fight_a_deep_one_leg_squat.txt";
          else if (hitId == 1)
            return "fight_a_turning_kick.txt";
          else if (hitId == 2)
            return "fight_a_squat_jab.txt";
          else 
            return "fight_a_high_kick.txt";          
        }
      }
    }

   
    if (currentAction.currentIdx == 0) {
      print("fuck");
      return "fight_b_guard_sway.txt";
    }
    
     // ================= fight ===============
     // -------- fight_a_deep_one_leg_squat ---------
    
    return null;
  }
}
