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

  public String firstAction;
  public String sessionName;
  public String bgSvg;
  public String bgOutline;
  
  public String choose(SkeletonData data, Action currentAction)
  {
    return null;
  } // end of String chooose
}
