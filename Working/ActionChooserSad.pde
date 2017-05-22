class ActionChooserSad extends ActionChooser
{
  public ActionChooserSad()
  {
    firstAction = "sad_int.txt";
    sessionName = "Sad";
    bgSvg = "sad-800.svg";
    bgOutline = "sad-outline.svg";
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
    String SadfileName = "a";
    
    
//    if (vecs[0].x > 400) {
//      switch(history[8]) {
//        case 1: 
//  //        println("Action: sad_loop");
//          SadfileName = "sad_loop";
//          break;
//        case 2: 
//  //        println("Action: sad_one_hand_throw_down");
//          SadfileName = "sad_one_hand_throw_down";
//          break;
//        case 3: 
//  //        println("Action: sad_throw_up_hands_frustrated");
//          SadfileName = "sad_throw_up_hands_frustrated";
//          break;
//        case 4: 
//  //        println("Action: sad_sigh_hands_down");
//          SadfileName = "sad_sigh_hands_down";
//          break;
//      }
//      if (history[8] == 4) {
//        history[8] = 1;
//      }
//      history[8]++;
//    }
//    
//    if (vecs[0].x < 400) {
//      historyBool[8] = true;
//    }
    
    if (vecs[0].x > 500)
      return null;
    
    // put your hand on his head 
    // left hand or right hand in an area
    if (
        (180 < vecs[15].x && vecs[15].x < 270) && (120 < vecs[15].y && vecs[15].y < 160)
        ||
        (180 < vecs[16].x && vecs[16].x < 270) && (120 < vecs[16].y && vecs[16].y < 160)
       )
       {
        println("touch his head");
        if (historyBool[0] == false) {
          historyBool[0] = true;
        }
       }
    else 
      historyBool[0] = false;
    
    
    
    // making decision
    if (SadfileName == "sad_loop") {
      println(history[8]);
      println(SadfileName);
      println("Action: sad_loop");
      return "sad_loop.txt";
    }
    else if (SadfileName == "sad_one_hand_throw_down") {
      println(history[8]);
      println(SadfileName);
      println("Action: sad_one_hand_throw_down");
      return "sad_one_hand_throw_down.txt";
    }
    else if (SadfileName == "sad_throw_up_hands_frustrated") {
      println(history[8]);
      println(SadfileName);
      println("Action: sad_throw_up_hands_frustrated");
      return "sad_throw_up_hands_frustrated.txt";
    }
    else if (SadfileName == "sad_sigh_hands_down") {
      println(history[8]);
      println(SadfileName);
      println("Action: sad_sigh_hands_down");
      return "sad_sigh_hands_down.txt";
    }
    else if (historyBool[0] == true) {
      return "sad_hug.txt";
    }
    
    else
      return null;
  
  } // end of String chooose
}
