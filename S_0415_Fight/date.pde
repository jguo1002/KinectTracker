void date(int userId) {
//  // to get the 3d joint data
//  PVector jointPos = new PVector();
//  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,jointPos);
//  println(jointPos.x, jointPos.y);
  
  int day = day();    // Values from 1 - 31
  int month = month();  // Values from 1 - 12
  int year = year();   // 2003, 2004, 2005, etc.
  int hour = hour();
  int minute = minute();
  int second = second();
  
  String a = "-";
  String b = ":";
  String vyear = String.valueOf(year);
  String vmonth = String.valueOf(month);
  String vday = String.valueOf(day);
  String vhour = String.valueOf(hour);
  String vminute = String.valueOf(minute);
  
  PVector joint = new PVector();
  float confidence = context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, joint);
  if(confidence < 0.5)
    return;
  PVector convertedJoint = new PVector();
  context.convertRealWorldToProjective(joint, convertedJoint);
  fill(0);
  text(vyear+a+vmonth+a+vday+" "+vhour+b+vminute, convertedJoint.x, convertedJoint.y-20);
//  println(vyear+a+vmonth+a+vday+" "+vhour+b+vminute);
}
