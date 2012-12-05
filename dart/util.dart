//Copyright (C) 2012-, AdaHeads K/S - This is free software; you can
//redistribute it and/or modify it under terms of the
//GNU General Public License  as published by the Free Software  Foundation;
//either version 3,  or (at your  option) any later version. This library is
//distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
//PARTICULAR PURPOSE. You should have received a copy of the
//GNU General Public License and a copy of the GCC Runtime Library Exception
//along with this program; see the files COPYING3 and COPYING.RUNTIME
//respectively. If not, see <http://www.gnu.org/licenses/>.
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