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
library Notification;

import '../bob.dart';
import 'model/call.dart';
import 'user_interface.dart';
import 'log.dart';
/**
 * Dispatches the Notifications from Alice.
 */
class Notification {
  static void Dispatch(Map json)
  {
    if (json.containsKey("persistent")){
      if (json["persistent"]){
        _persistent(json);
      }else{
        _nonpersistent(json);
      }
    }else{
      print ("Notification without persistent");
    }
  }

  static void _persistent(Map json){
    print("_persistent");
  }

  static void _nonpersistent (Map json){
    if (json.containsKey("event")){

      switch(json["event"]) {
        case "new_call":
          if (json.containsKey("call")){
            Call c = new Call.fromJSON(json["call"]);
            Bob.Call_List.insert_Call(c);
            //Reload_Call_List(Call_List);
          }
          break;

        case "hangup_call":
          if (json.containsKey("call")){
            var c = json["call"];
            var id = c["call_id"];
            Call call_to_remove;
            int index = 0;

            Bob.Call_List.Remove_Call(id);
          }

          break;
        case "agent_state":
        default:
          var e = json["event"];
          Log.Message(Level.DEBUG, "Unknown event $e", "notification.dart");
      }
    }
  }
}