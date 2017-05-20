class ActionChooser
{
  public ActionChooser()
  {
    history = new int[10];
    historyBool = new boolean[10];
    fightNUM = new int[10];
    fightBool = new boolean[10];
    sadNUM = new int[10];
    sadBool = new boolean[10];
    happyNUM = new int[20];
    happyBool = new boolean[20];
    danceNUM = new int[10];
    danceTime = new int[10];
    danceBool = new boolean[10];
    for (int i = 0; i < 10; i++)
    {
      history[i] = 0;
      historyBool[i] = false;
      fightNUM[i] = 0;
      fightBool[i] = false;
      sadNUM[i] = 0;
      sadBool[i] = false;
      danceNUM[i] = 0;
      danceTime[i] = 0;
      danceBool[i] = false;
    }
   for (int i = 0; i < 10; i++) 
   {
     happyNUM[i] = 0;
     happyBool[i] = false;
   }
  }
  
  public int[] history;
  public boolean[] historyBool;
  public int[] fightNUM;
  public boolean[] fightBool;
  public int[] sadNUM;
  public boolean[] sadBool;
  public int[] happyNUM;
  public boolean[] happyBool;
  public int[] danceNUM;
  public int[] danceTime;
  public boolean[] danceBool;
  int danceAction = 0;
  
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
    
    // if user walk to left of stage
    if (vecs[0].x < 300)
      historyBool[0] = true;
    if (historyBool[0] == true && currentFileName != "fight_go_back.txt") {
      historyBool[0] = false;
      return "fight_go_back.txt";
    }
/*
    // ================= fight ===============
    // -------- fight_a_deep_one_leg_squat ---------
    if (460 < vecs[11].x && vecs[11].x < 480 && 560 < vecs[14].x && vecs[14].x < 580) {
      // user stand at certain place
      currentFileName = "fight_a_deep_one_leg_squat.txt";
      fightBool[3] = true;
      fightNUM[3] = 0; // not disturbed by default action
      return null;
    }

    // --------- a: high_kick ---------- fightNUM[0], fightBool[0]
    if (490 < vecs[0].x && vecs[0].x < 510 && fightBool[0] == false) {
      fightBool[0] = true;
    }
      fightNUM[0]++;
      if (fightNUM[0] == 31)
        fightNUM[0] = 0;
//      println(vecs[0].x);
    if (fightBool[0] == true && fightNUM[0] == 30 && currentFileName != "fight_a_high_kick.txt") {
      println("kick");
      fightBool[0] = false;
      fightBool[3] = true;
      fightNUM[3] = 0; // not disturbed by default action
      currentFileName = "fight_a_high_kick.txt";
      return null;
    }
    
    // -------------- a: turning kick -------------
    if (530 < vecs[0].x && vecs[0].x < 540) {
      // user stand at a certain place
      fightBool[2] = true;
    }
    if (fightBool[2] == true && currentFileName != "fight_a_turning_kick.txt") {
      fightBool[2] = false;
      fightBool[3] = true;
      fightNUM[3] = 0; // not disturbed by default action
      currentFileName = "fight_a_turning_kick.txt";
      return null;
    }
    
    // --------------- a: jab ------------ fightNUM[2]
    if (530 < vecs[7].x &&  vecs[7].x < 550) {
      fightNUM[2]++;
      if (fightNUM[2] > 30 && currentFileName != "fight_a_squat_jab.txt") {
        // stay at certain position for 1s
        fightNUM[2] = 0;
        fightBool[3] = true;
        fightNUM[3] = 0; // not disturbed by default action
        return "fight_a_squat_jab.txt";
      }
    }

    // ------------- b: be hit ----------- fightBool[1], fightNUM[1]
    if (vecs[0].x < 500) {
      // if left hand near left shoulder 
      if (vecs[2].x - vecs[16].x < 40) {
        fightBool[1] = true;
      }
      if (fightBool[1] == true) {
        fightNUM[1]++;
      }
      if (fightNUM[1] == 30)
        fightNUM[1] = 0;
      
      // if right hand near right shoulder
      if  (abs(vecs[5].x - vecs[15].x) < 40) {
        fightBool[5] = true;
      }
      if (fightBool[5] == true)
        fightNUM[5]++;
      if (fightNUM[5] == 30)
        fightNUM[5] = 0;
      
      // recognize punching
      if (
          (fightBool[1] == true && fightNUM[1] < 30 // punch within 1s
          && (vecs[2].x - vecs[16].x > 100)) // punch left fist
          ||
          (fightBool[5] == true && fightNUM[5] < 30 // punch within 1s
          && (vecs[5].x - vecs[15].x > 100))
          ) {
          fightBool[6] = true;
          fightNUM[9]++; // record how many times matchman be hit
          }
      
      // if user punches
      if (fightBool[6] == true) {
        // ----- be hit stomatch -------
        if ((vecs[16].y > 240 || vecs[15].y > 240)
              && currentFileName != "fight_b_be_kicked_stomach.txt"
              && currentFileName != "fight_b_dodge_left_one_hand_up.txt") {
          float fHitStomach = random(0,2);
          int iHitStomach = int(fHitStomach);
          // response randomly
          if (iHitStomach == 0)
          {
            fightBool[1] = false; // detect left hand
            fightBool[5] = false; // detect right hand
            fightBool[6] = false; // user punches
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_be_kicked_stomach.txt";
          }
          if (iHitStomach == 1) 
          {
            fightBool[1] = false; // detect left hand
            fightBool[5] = false; // detect right hand
            fightBool[6] = false; // user punches
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_dodge_left_one_hand_up.txt";
          }
        } // end y > 240
        
        // ----- be hit head ------
        else if ((vecs[16].y < 240 || vecs[15].y < 240)
                  && currentFileName != "fight_b_be_hit_turning.txt"
                  && currentFileName != "fight_b_high_guard.txt"
                  && currentFileName != "fight_b_be_hit_turning_2.txt"
                  && currentFileName != "fight_b_be_hit_head_up.txt") {
          float fHitHead = random(0,2);
          int iHitHead = int(fHitHead);
          if (iHitHead == 0) 
          {
            fightBool[1] = false; // detect left hand
            fightBool[5] = false; // detect right hand
            fightBool[6] = false; // user punches
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_high_guard.txt";
          }
          if (iHitHead == 1) 
          {
            fightBool[1] = false; // detect left hand
            fightBool[5] = false; // detect right hand
            fightBool[6] = false; // user punches
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_be_hit_turning.txt";
          }
          if (iHitHead == 2) 
          {
            fightBool[1] = false; // detect left hand
            fightBool[5] = false; // detect right hand
            fightBool[6] = false; // user punches
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_be_hit_turning_2.txt";
          }
          if (iHitHead == 3) 
          {
            fightBool[1] = false; // detect left hand
            fightBool[5] = false; // detect right hand
            fightBool[6] = false; // user punches
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_be_hit_head_up.txt";
          }
        } // end y < 200
      }
    } // end of be hit stomach
    

    
    // ---------------- b: be kicked ------------- fightNUM[4]
    // feet on the ground
    if (abs(vecs[11].y - vecs[14].y) < 20) {
      fightBool[4] = true;
    }
    if (fightBool[4] == true) {
      fightNUM[4]++;
    }
    if (fightNUM[4] > 30)
      fightNUM[4] = 0;
    
    // if user kicks
    if (
        fightNUM[4] < 30 
        && abs(vecs[14].x - vecs[11].x) > vecs[5].x - vecs[2].x // two feet wider than shoulders
        && (
            (vecs[11].y < vecs[14].y && vecs[11].x < vecs[14].x) // kick left foot
            || 
            (vecs[11].y > vecs[14].y && vecs[11].x > vecs[14].x) // kick right foot
           )
        )
     {
       fightNUM[9]++; // record how many times matchman be hit
       // low kick
       if (
           abs(vecs[14].y - vecs[11].y) > ((vecs[1].y - vecs[0].y)/2)
           && abs(vecs[14].y - vecs[11].y) < vecs[1].y - vecs[0].y
           && currentFileName != "fight_b_LowKick_jump_back_one_leg.txt"
           && currentFileName != "fight_b_LowKick_jump_back.txt"
           && currentFileName != "fight_b_LowKick_onKnee.txt"
           && currentFileName != "fight_b_LowKick_grab_ankle.txt")
       {
          float fLowKick = random(0,4);
          int iLowKick = int(fLowKick);
          // response randomly
          if (iLowKick == 0)
          {
            fightBool[4] = false; // restart detect kicking
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_LowKick_grab_ankle.txt";
          }
          if (iLowKick == 1)
          {
            fightBool[4] = false; // restart detect kicking
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_LowKick_jump_back_one_leg.txt";
          }
          if (iLowKick == 2)
          {
            fightBool[4] = false; // restart detect kicking
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_LowKick_jump_back.txt";
          }
          if (iLowKick == 3)
          {
            fightBool[4] = false; // restart detect kicking
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_LowKick_onKnee.txt";
          }
       } // end of low kick
       // high kick 
       if (abs(vecs[14].y - vecs[11].y) > vecs[1].y - vecs[0].y
           && currentFileName != "fight_b_HighKick_fly_ground.txt"
           && currentFileName != "fight_b_HighKick_ground_legs_2.txt"
           && currentFileName != "fight_b_HighKick_ground_legs_3.txt"
           && currentFileName != "fight_b_HighKick_ground_legs.txt"
           && currentFileName != "fight_b_HighKick_side_one_leg.txt")
       {
          float fHighKick = random(0,4);
          int iHighKick = int(fHighKick);
          // response randomly
          if (iHighKick == 0)
          {
            fightBool[4] = false; // restart detect kicking
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_HighKick_fly_ground.txt";
          }
          if (iHighKick == 1)
          {
            fightBool[4] = false; // restart detect kicking
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_HighKick_ground_legs_2.txt";
          }
          if (iHighKick == 2)
          {
            fightBool[4] = false; // restart detect kicking
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_HighKick_ground_legs_3.txt";
          }
          if (iHighKick == 3)
          {
            fightBool[4] = false; // restart detect kicking
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_HighKick_ground_legs.txt";
          }
          if (iHighKick == 4)
          {
            fightBool[4] = false; // restart detect kicking
            fightBool[3] = true;
            fightNUM[3] = 0; // not disturbed by default action
            return "fight_b_HighKick_side_one_leg.txt";
          }
       }
     } // end of kick
      
    if (fightNUM[9] == 40) {
      fightNUM[9] = 0;
      currentFileName = "fight_b_surrend";
      return null;
    }
    // ---------------- default action ------------
    println("fightNUM[3]: " + fightNUM[3]);
    if (fightBool[3] == true) 
      fightNUM[3]++;
    if (fightNUM[3] > 60) {
      // last action last about 3s
      fightBool[3] = false;
      return "fight_b_guard_sway.txt";
//      currentFileName = "fight_b_guard_sway.txt";
    }
    return null;

    
    
*/
/*
    // ============ sad ===============
    // ------------ loop ------------ sadNUM[0]
    if(vecs[0].x > 540) {
      sadNUM[0]++;
      if (sadNUM[0] > 40 && currentFileName != "sad_loop.txt") {
        sadNUM[0] = 0;
        return "sad_loop.txt";
      }
    }
    // ----------- sad_throw_up_hands_frustrated ---------- sadNUM[1]
    if( 500 < vecs[0].x && vecs[0].x < 540) {
      sadNUM[1]++;
      if (sadNUM[1] > 40 && currentFileName != "sad_throw_up_hands_frustrated.txt") {
        sadNUM[1] = 0;
        return "sad_throw_up_hands_frustrated.txt";
      }
    }
    // ----------- sad_beat_breast ---------- sadNUM[2]
    if( 440 < vecs[0].x && vecs[0].x < 500) {
      sadNUM[2]++;
      if (sadNUM[2] > 40 && currentFileName != "sad_beat_breast.txt") {
        sadNUM[2] = 0;
        return "sad_beat_breast.txt";
      }
    }

    // -------------- touch head ------------ sadNUM[3]
    if (vecs[0].x < 440 
        && 310 < vecs[16].x && vecs[16].x < 350 
        && 110 < vecs[16].y && vecs[16].y < 210) 
    {
      sadNUM[3]++;
      println("sadNUM[3]: " + sadNUM[3]);
      float fTouchHead = random(0,2);
      int iTouchHead = int(fTouchHead);
      // response randomly
      if (sadNUM[3] > 60 && iTouchHead == 0 && currentFileName != "sad_hug_2.txt"){
        sadNUM[3] = 0;
        return "sad_hug_2.txt"; // "sad_hug.txt" is too far away from user
      }
      if (sadNUM[3] > 60 && iTouchHead == 1 && currentFileName != "sad_turning_no.txt"){
        sadNUM[3] = 0;
        return "sad_turning_no.txt";
      }
    }
    
    // -------------- hug_keep ------------ 
    if (currentFileName == "sad_hug_2.txt" && vecs[0].x < 440) { 
        currentFileName = "sad_hug_keep.txt";
        return null;
    }
    if (currentFileName == "sad_hug_2.txt" && currentFileName == "sad_hug_keep.txt" && vecs[0].x > 500) {
      currentFileName = "sad_dont_go_2.txt";
      return null;
    }
    
    // -------------- tears ------------ 
    if (vecs[1].x - vecs[15].x > 30) 
      sadNUM[4]++;
    if (sadNUM[4] > 30 && currentFileName != "sad_tears.txt") {
      sadNUM[4] = 0;
      return "sad_tears.txt";
    }
*/
/*
    //================== happy ===================
    // -------------- vecs16_up ------------- happyNUM[0][1], happyBool[0][1]
    if (vecs[16].y < vecs[7].y)
      happyBool[0] = true; 
    if (happyBool[0] == true)
      happyNUM[0]++; // start timing
    if (happyNUM[0] == 30)
      happyNUM[0] = 0; 
    if (happyNUM[0] < 30 && vecs[0].y - vecs[16].y > 50) // 1s to raise your hand
      happyBool[1] = true; 
    if (happyBool[1] == true)
      happyNUM[1]++; // start timing for raising hand
    if (happyNUM[1] > 20 && currentFileName != "happy_vecs16_up.txt") {
      // raise hand for 1.5s
      happyBool[0] = false;
      happyBool[1] = false;
      happyNUM[0] = 0;
      happyNUM[1] = 0;
      return "happy_vecs16_up.txt";
    }
    // -------------- vecs15_up ------------- happyNUM[2][3], happyBool[2][3]
        if (vecs[15].y < vecs[7].y)
      happyBool[2] = true; 
    if (happyBool[2] == true)
      happyNUM[2]++; // start timing
    if (happyNUM[2] == 30)
      happyNUM[2] = 0; 
    if (happyNUM[2] < 30 && vecs[0].y - vecs[15].y > 50) // 1s to raise your hand
      happyBool[3] = true; 
    if (happyBool[3] == true)
      happyNUM[3]++; // start timing for raising hand
    if (happyNUM[3] > 20 && currentFileName != "happy_vecs15_up.txt") {
      // raise hand for 1.5s
      happyBool[2] = false;
      happyBool[3] = false;
      happyNUM[2] = 0;
      happyNUM[3] = 0;
      return "happy_vecs15_up.txt";
    }
    
    // -------------- foot_kick_back -------------
    if (360 < vecs[0].x && vecs[0].x < 400
        && vecs[15].y - vecs[0].y < 140
        && vecs[16].y - vecs[0].y < 140
        && currentFileName != "happy_kick_foot_back.txt")
      return "happy_kick_foot_back.txt";
    
    else {
      currentFileName = "happy_0.txt";
      return null;
    }
*/

    // =============== Dance ======================
/*
    // --------------- a0 ------------ danceTime[0][10], danceBool[0], danceNUM[0]
    danceTime[9]++; // after the init action, start interaction
    if (danceTime[9] > 300 && danceAction == 0) {
      danceTime[0]++;

      float feetdistance = abs(vecs[11].x - vecs[14].x);
//      println("feetdistance: " + feetdistance);
      if (feetdistance < 20){
        danceBool[0] = true; // if feet meet
      }
      if (feetdistance > 100 && danceBool[0] == true){
        danceNUM[0]++;
        danceBool[0] = false;
      }
      
      if (danceNUM[0] == 4 && currentFileName != "dance_clap.txt"){
        danceNUM[0] = 0;
        danceAction++;
        danceTime[0] = 0;
        return "dance_clap.txt";
      }
      else if (danceTime[0] > 1200)
      {
        // more than 40s, matchman goes alway
        currentFileName = "dance_g_shrug.txt";
        danceAction++;
      }
      else {
        float fA0 = random(0,7);
        int iA0 = int(fA0);
        switch(iA0) {
          case 0: currentFileName = "dance_A0_head_a0_me_invite.txt";
          break;
          case 1: currentFileName = "dance_A0_head_no_me_a0_you.txt";
          break;
          case 2: currentFileName = "dance_A0_hip_no_me_a0_invite_two.txt";
          break;
          case 3: currentFileName = "dance_A0_me_a0_invite_two.txt";
          break;
          case 4: currentFileName = "dance_A0_me_a0_invite.txt";
          break;
          case 5: currentFileName = "dance_A0_no_me_a0_invite.txt";
          break;
          case 6: currentFileName = "dance_A0_no_two_a0_you.txt";
          break;
        }
        return null;
      }
    } // end of a0
*/

    // ------------------ a1 rasise hand ----------- danceNUM[1], danceTimep[1]
    if (danceAction == 0) { // for test
//    if (danceAction == 1) {
      danceTime[1]++;
      if (vecs[0].y - vecs[16].y > 50)
        danceNUM[1]++;
     
      float hand_head_distance = vecs[0].y - vecs[16].y;
      float hand_elbow_distance = vecs[3].y - vecs[16].y;
      println("danceNUM[1]: " + danceNUM[1]);
      println("hand_head_distance: " + hand_head_distance);
      println("distance: " + (hand_head_distance - hand_elbow_distance));
//      println("head: " + vecs[0].x);
      
      // if user is in certain area, one hand up, one hand down
      if (
          470 < vecs[0].x && vecs[0].x < 520
          && hand_head_distance >  hand_elbow_distance
          && danceNUM[1] > 30
          && vecs[15].y > vecs[7].y
          && currentFileName != "dance_A1_b_turn_around.txt"
          )
      {
        println("dance!");
        danceNUM[1] = 0;
        danceAction++;
        danceTime[1] = 0;
        return "dance_A1_b_turn_around.txt";
//        currentFileName = "dance_A1_b_turn_around.txt";
//        return null;
      }
      else if (danceTime[1] > 1200)
      {
        // more than 40s, matchman goes alway
        currentFileName = "dance_g_shrug.txt";
        danceAction++;
      }
      
      println("nonono");
      float fA1 = random(0,7);
      int iA1 = int(fA1);
      switch(iA1) {
        case 0: currentFileName = "dance_A1_head_me_at_invite.txt";
                println("0");
                return null;
        case 1: currentFileName = "dance_A1_head_no_a1_me_you_two.txt";
                println("1");
                return null;
        case 2: currentFileName = "dance_A1_hips_no_a1_you_two.txt";
                println("2");
                return null;
        case 3: currentFileName = "dance_A1_me_a1_invite_two.txt";
                println("3");
                return null;
        case 4: currentFileName = "dance_A1_me_a1_invite.txt";
                println("4");
                return null;
        case 5: currentFileName = "dance_A1_no_me_a1_invite_two.txt";
                return null;
        case 6: currentFileName = "dance_A1_no_two_me_a1_you.txt";
                return null;
        }
      
    } // end of a1

/*
// ------------------ a2 kick ----------- danceTimep[2]
    if (danceAction == 0) { // for test
//    if (danceAction == 2) {
      danceTime[2]++;
      if (
          // in certain area
          470 < vecs[0].x && vecs[0].x < 520
          // hand between hip and torso
          && vecs[7].y < vecs[16].y && vecs[16].y < vecs[8].y 
          && vecs[2].x - vecs[3].x > 30 // left elbow away from left shoulder
          )
      {
        currentFileName = "dance_clap.txt";
        return null;
      }
      else if (danceTime[2] > 1200)
      {
        // more than 40s, matchman goes alway
        currentFileName = "dance_g_shrug.txt";
        danceAction++;
      }
      else if (danceTime[2] < 600)
      {
        float fA2S = random(0,4);
        int iA2S = int(fA2S);
        switch(iA2S) {
          case 0: currentFileName = "dance_A2_me_a2_invite_two.txt";
          break;
          case 1: currentFileName = "dance_A2_me_a2_invite.txt";
          break;
          case 2: currentFileName = "dance_A2_no_me_a2_invite.txt";
          break;
          case 3: currentFileName = "dance_A2_no_me_invite_two.txt";
          break;
        }
      }
      else {
        // if it takes more time, matchman will lose patience
        float fA2L = random(0,4);
        int iA2L = int(fA2L);
        switch(iA2L) {
          case 0: currentFileName = "dance_A2_fold_no_me_a2_you.txt";
          break;
          case 1: currentFileName = "dance_A2_hip_a2_me_you.txt";
          break;
          case 2: currentFileName = "dance_A2_hip_no_me_a2_you.txt";
          break;
          case 3: currentFileName = "dance_A2_sigh_me_a2_invite_two.txt";
          break;
        }
      }
    }


// ------------------ a3 squat ----------- danceTimep[3]
    if (danceAction == 0) { // for test
//    if (danceAction == 3) {
      danceTime[3]++;
      if (
          // in certain area
          470 < vecs[0].x && vecs[0].x < 520
          && vecs[0].y > 130 // squat 
          && vecs[15].x - vecs[5].x > 100 // reach out hand 
          && vecs[0].x > vecs[7].x // body forward
          )
      {
        currentFileName = "dance_clap.txt";
        return null;
      }
      else if (danceTime[3] > 1200)
      {
        // more than 40s, matchman goes alway
        currentFileName = "dance_g_shrug.txt";
        danceAction++;
      }
      else {
        float fA3 = random(0,8);
        int iA3 = int(fA3);
        switch(iA3) {
          case 0: currentFileName = "dance_A3_fold_no_a3_you_two.txt";
          break;
          case 1: currentFileName = "dance_A3_hip_no_me_a3_invite_two.txt";
          break;
          case 2: currentFileName = "dance_A3_me_two_a3_you.txt";
          break;
          case 3: currentFileName = "dance_A3_no_me_a3_you.txt";
          break;
          case 4: currentFileName = "dance_A3_sigh_no_a3_invite_two.txt";
          break;
          case 5: currentFileName = "dance_A3_warm_me_a3_invite.txt";
          break;
          case 6: currentFileName = "dance_A3_warm_me_a3_invitie_two.txt";
          break;
          case 7: currentFileName = "dance_A3_warm_no_me_a3_invite.txt";
          break;
        }
      }
    }
  */ 
 /* 
    // ------------------ a4 squat two ----------- danceTimep[4]
    if (danceAction == 0) { // for test
//    if (danceAction == 4) {
      danceTime[4]++;
      if (
          // in certain area
          470 < vecs[0].x && vecs[0].x < 520
          && vecs[0].y > 130 // squat
          && vecs[12].x - vecs[9].x > 160 // two knees outward
          && (vecs[2].x - vecs[16].x) > (vecs[7].y - vecs[0].y) // left arm stretch
          && (vecs[5].x - vecs[15].x) > (vecs[7].y - vecs[0].y)
          )
      {
        currentFileName = "dance_clap.txt";
        return null;
      }
      else if (danceTime[4] > 1200)
      {
        // more than 40s, matchman goes alway
        currentFileName = "dance_g_shrug.txt";
        danceAction++;
      }
      else {
        float fA4 = random(0,8);
        int iA4 = int(fA4);
        switch(iA4) {
          case 0: currentFileName = "dance_A4_a4_you_me_a4_you_two.txt";
          break;
          case 1: currentFileName = "dance_A4_arms_me_a4_invite_two.txt";
          break;
          case 2: currentFileName = "dance_A4_fold_me_a4_you_two.txt";
          break;
          case 3: currentFileName = "dance_A4_hip_no_me_a4_you.txt";
          break;
          case 4: currentFileName = "dance_A4_legs_me_a4_invite.txt";
          break;
          case 5: currentFileName = "dance_A4_me_a4_invite_two_a4_you.txt";
          break;
          case 6: currentFileName = "dance_A4_no_me_a4_invite_a4.txt";
          break;
          case 7: currentFileName = "dance_A4_no_me_a4_you.txt";
          break;
        }
      }
    }
  
    // ------------------ a5 squat two ----------- danceTimep[5]
    if (danceAction == 0) { // for test
//    if (danceAction == 5) {
      danceTime[5]++;
      println("vecs[0].x: " + vecs[0].x);
      println("vecs[0].y: " + vecs[0].y);
      float knees_distance = vecs[12].x - vecs[9].x;
      float right_shoulder = vecs[5].y - vecs[15].y;
      float elbow_hand = vecs[6].x - vecs[15].x;
      float neck_torso = vecs[1].x - vecs[7].x;
      println("knees_distance: " + knees_distance);
      println("right_shoulder: " + right_shoulder);
      println("elbow_hand: " + elbow_hand);
      println("neck_torso: " + neck_torso);
      if (
          // in certain area
          470 < vecs[0].x && vecs[0].x < 540
          && vecs[0].y > 130 // squat
          && vecs[12].x - vecs[9].x > 160 // two knees outward
          && vecs[5].y > vecs[15].y // raise right hand
          && vecs[6].x > vecs[15].x // right elbow out of right hand
          && vecs[1].x > vecs[7].x // neck out of torso
          )
      {
        currentFileName = "dance_clap.txt";
        return null;
      }
      else if (danceTime[5] > 1200)
      {
        // more than 40s, matchman goes alway
        currentFileName = "dance_g_shrug.txt";
        danceAction++;
      }
      else {
        float fA5 = random(0,8);
        int iA5 = int(fA5);
        switch(iA5) {
          case 0: currentFileName = "dance_A5_fold_no_a5_invite.txt";
          break;
          case 1: currentFileName = "dance_A5_hip_me_squat_a5_you.txt";
          break;
          case 2: currentFileName = "dance_A5_invite_a5_invite.txt";
          break;
          case 3: currentFileName = "dance_A5_invite_two_a5_you.txt";
          break;
          case 4: currentFileName = "dance_A5_me_squat_a5_you.txt";
          break;
          case 5: currentFileName = "dance_A5_no_me_a5_you.txt";
          break;
          case 6: currentFileName = "dance_A5_warm_me_a5_invite.txt";
          break;
          case 7: currentFileName = "dance_A5_warm_me_a5_you.txt";
          break;
        }
      }
    }
*/
     return null;
      
  } // end of String chooose
}
