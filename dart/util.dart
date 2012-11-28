library Util;

import 'dart:math';

class Util {
   static String Random_String(int length){
      StringBuffer text = new StringBuffer();
      String range = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      var rnd = new Random();

      for(int i = 0; i < length; i++){
        text.add(range[rnd.nextInt(range.length)]);
      }

      return text.toString();
   }

   static int Time_In_UTC([Date time]){
     int TimeInUTC;
     Date Clock = new Date.now();

     if (?time){
       Clock = time;
     }

     TimeInUTC = Clock.toUtc().millisecondsSinceEpoch;

     return TimeInUTC;
   }
}