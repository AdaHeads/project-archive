library Adaheads;

import 'dart:math';

class Adaheads {
   static String Random_String(int length){
      StringBuffer text = new StringBuffer();
      String range = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      var rnd = new Random();

      for(int i = 0; i < length; i++){
        text.add(range[rnd.nextInt(range.length)]);
      }

      return text.toString();
   }
}