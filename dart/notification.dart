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